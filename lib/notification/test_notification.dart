import 'package:abrar/notification/fcm_sender.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notification_service.dart';

class TestNotification extends StatelessWidget {
  const TestNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Notification'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            //
            Row(
              spacing: 16,
              children: [
                //
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity(
                        horizontal: -3,
                        vertical: -3,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      await FirebaseMessaging.instance.subscribeToTopic('All');
                      // show msg
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Subscribed to All')),
                      );
                    },
                    child: Text('Subscribe To Topic'),
                  ),
                ),

                //
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity(
                        horizontal: -3,
                        vertical: -3,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      await FirebaseMessaging.instance.unsubscribeFromTopic(
                        'All',
                      );

                      //
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unsubscribed from All')),
                      );
                    },
                    child: Text('Unsubscribe From Topic'),
                  ),
                ),
              ],
            ),

            //
            Row(
              spacing: 16,
              children: [
                //
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity(
                        horizontal: -3,
                        vertical: -3,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      final topic = 'All';
                      final title = 'Welcome to All';
                      final body = 'Visit our shop';
                      final data = {'type': 'notifications'};

                      //
                      final type = 'notifications';

                      //
                      FCMSender.sendToTopic(
                        topic: topic,
                        title: title,
                        body: body,
                        data: data,
                      );

                      //
                      await NotificationService.addNotification(
                        type: type,
                        title: title,
                        body: body,
                        data: data,
                      );

                      // show msg
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Send Notification(All)')),
                      );
                    },
                    child: Text('Send Notification(All)'),
                  ),
                ),

                //
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity(
                        horizontal: -3,
                        vertical: -3,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      var token = await FirebaseMessaging.instance.getToken();
                      if (token == null) return;

                      final title = 'Hello User';
                      final body = 'Visit our shop';
                      final data = {'type': 'notifications'};

                      //
                      final type = 'notifications';

                      //
                      FCMSender.sendToToken(
                        token: token,
                        title: title,
                        body: body,
                        data: data,
                      );

                      //
                      await NotificationService.addNotification(
                        type: type,
                        title: title,
                        body: body,
                        data: data,
                      );

                      //
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notification to: $token')),
                      );
                    },
                    child: Text('Send Notification(Single)'),
                  ),
                ),
              ],
            ),

            //
            Row(
              spacing: 16,
              children: [
                //
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity(
                        horizontal: -3,
                        vertical: -3,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      final topic = 'All';
                      final title = 'Discount Offer!';
                      final body = 'Lavely Fan';
                      final data = {
                        'type': 'products',
                        'productId': '1722194435624',
                      };

                      //
                      final type = 'products';

                      //
                      FCMSender.sendToTopic(
                        topic: topic,
                        title: title,
                        body: body,
                        data: data,
                      );

                      //
                      await NotificationService.addNotification(
                        type: type,
                        title: title,
                        body: body,
                        data: data,
                      );

                      // show msg
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product Notification')),
                      );
                    },
                    child: Text('Product Notification'),
                  ),
                ),

                //
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
