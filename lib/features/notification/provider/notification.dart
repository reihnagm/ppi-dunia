import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import 'package:soundpool/soundpool.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  Future<void> initLocation() async {
    final loc = await Geolocator.requestPermission();

    if (loc == LocationPermission.whileInUse ||
        loc == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();

      SharedPrefs.writeLatLng(position.latitude, position.longitude);
    }
  }

  Future<void> initNotification() async {
    final notificationRequest = await Permission.notification.request();

    if (notificationRequest.isDenied ||
        notificationRequest.isPermanentlyDenied) {
      await GeneralModal.dialogRequestNotification(
          msg:
              "Fitur notifikasi dibutuhkan, silahkan aktifkan notifikasi Anda");
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
                "Fitur notifikasi dibutuhkan, silahkan aktifkan notifikasi Anda");
      }
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        initNotification();
      });
    }

    notifyListeners();
  }
}
