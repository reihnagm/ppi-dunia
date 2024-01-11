import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/utils/global.dart';
import 'package:ppidunia/features/inbox/presentation/pages/detail_inbox/detail_inbox_state.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'notification',
      'notification_channel',
      channelDescription: 'notification_channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      channelShowBadge: true,
      enableVibration: true,
      enableLights: true,
    );
    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(
        presentBadge: true,
        presentSound: true,
        presentAlert: true,
      ),
    );
  }

  static Future init(BuildContext context) async {
    InitializationSettings settings = const InitializationSettings(
    android: AndroidInitializationSettings('@drawable/ic_notification'),
    iOS: DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    ));

    await notifications.initialize(settings,
      onDidReceiveNotificationResponse: (details) {
        var payload = details.payload;
        var decoded = json.decode(payload!);
        
        NS.push(
          navigatorKey.currentContext!,
          DetailInbox(
            type: decoded["type"],
            title: decoded["title"],
            name:decoded["name"],
            date: DateHelper.formatDateTime(decoded["date"]),
            description:decoded["description"],
          ));
        // debugPrint("Hallo");
        // debugPrint(decoded["title"]);
        // debugPrint(decoded["type"]);
        // debugPrint(decoded["date"]);
        // debugPrint(decoded["description"]);
        // debugPrint(decoded["name"]);
      },
    );
  }

  static Future showNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
  }) async {
    notifications.show(
      id!,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }
}
