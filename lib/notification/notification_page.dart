import 'package:abrar/notification/test_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '/routes/router_config.dart';
import '../routes/app_route.dart';
import 'notification_model.dart';
import 'notification_provider.dart';

class NotificationPage extends ConsumerStatefulWidget {
  final String userId;

  const NotificationPage({super.key, required this.userId});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  final ScrollController _controller = ScrollController();
  DocumentSnapshot? lastDoc;
  bool isLoadingMore = false;
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore) return;
    isLoadingMore = true;

    final repo = ref.read(notificationRepositoryProvider);
    final stream = repo.getNotifications(
      userId: widget.userId,
      startAfter: lastDoc,
      limit: 20,
    );
    final snapshot = await stream.first;
    if (snapshot.isNotEmpty) {
      lastDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('notifications')
          .doc(snapshot.last.id)
          .get();
      notifications.addAll(snapshot);
      setState(() {});
    }

    isLoadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    final asyncNotifications = ref.watch(
      notificationsStreamProvider(widget.userId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          // todo: admin test only
          if (widget.userId == "asifreyad1@gmail.com")
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestNotification()),
                );
              },
              icon: Icon(Iconsax.notification_favorite),
            ),
        ],
      ),
      body: asyncNotifications.when(
        data: (list) {
          notifications = list;
          // if no notifications then show msg
          if (notifications.isEmpty) {
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  Icon(Iconsax.notification, size: 80, color: Colors.grey),
                  Text(
                    'No notifications yet',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          //
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 8),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              controller: _controller,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notificationModel = notifications[index];

                //
                return Material(
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: notificationModel.read
                        ? Colors.grey.shade100
                        : Colors.blueAccent.shade100.withValues(alpha: .2),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -1),
                    title: Row(
                      children: [
                        Expanded(child: Text(notificationModel.title)),
                        Text(
                          timeAgo(notificationModel.createdAt),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    subtitle: Text(notificationModel.body),

                    onTap: () async {
                      // mark as read
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userId)
                          .collection('notifications')
                          .doc(notificationModel.id)
                          .update({'read': true});
                      // handle navigation based on type
                      switch (notificationModel.type) {
                        case 'products':
                          final productId = notificationModel.data['productId'];
                          if (productId != null) {
                            routerConfig.push(
                              AppRoute.productDetails.path,
                              extra: productId,
                            );
                          }
                          break;
                        // todo: fix later
                        case 'offers':
                          final offerId = notificationModel.data['offerId'];
                          if (offerId != null) {
                            routerConfig.push(
                              AppRoute.productDetails.path,
                              extra: offerId,
                            );
                          }
                          break;
                        default:
                          routerConfig.push(AppRoute.home.path);
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

String timeAgo(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
