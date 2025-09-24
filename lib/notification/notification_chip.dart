import 'package:abrar/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'notification_provider.dart';

class NotificationIconButton extends ConsumerWidget {
  final String userId;

  const NotificationIconButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadAsync = ref.watch(unreadCountProvider(userId));

    return Stack(
      children: [
        IconButton.filledTonal(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            context.push(AppRoute.notifications.path, extra: userId);
          },
          icon: const Icon(Iconsax.notification, size: 18),
        ),
        unreadAsync.when(
          data: (count) => count > 0
              ? Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : const SizedBox(),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}
