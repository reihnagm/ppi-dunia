import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:rxdart/rxdart.dart';

import 'package:soundpool/soundpool.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationNotifier with ChangeNotifier {
  NotificationNotifier() {
    isDialogShowing = false; // Prevent call twice
  }

  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  final soundpool = Soundpool.fromOptions(
    options: SoundpoolOptions.kDefault,
  );

  bool isDialogShowing = false;

  Future<void> initNotification() async {
    final notificationRequest = await Permission.notification.request();

    if (notificationRequest.isDenied ||
        notificationRequest.isPermanentlyDenied) {
      await GeneralModal.dialogRequestNotification(
          msg:
              "Notification needed, please activate your notification");
    }
  }

  void cancelDialog() {
    isDialogShowing = false;

    notifyListeners();
  }

  Future<void> checkNotification() async {
    var notificationRequest = await Permission.notification.isDenied ||
        await Permission.notification.isPermanentlyDenied;

    if (notificationRequest) {
      if (!isDialogShowing) {
        isDialogShowing = true;
        await GeneralModal.dialogRequestNotification(
            msg:
                "Notification feature needed, please activate your notification");
      }
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        initNotification();
      });
    }

    notifyListeners();
  }
}
