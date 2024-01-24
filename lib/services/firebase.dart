import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/helpers/date_util.dart';
import 'package:ppidunia/common/utils/global.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_detail/comment_detail.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_state.dart';
import 'package:ppidunia/features/inbox/presentation/pages/detail_inbox/detail_inbox_state.dart';
import 'package:ppidunia/features/inbox/presentation/pages/inbox_screen_model.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:soundpool/soundpool.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';

import 'package:ppidunia/features/firebase/data/repositories/firebase.dart';

import 'package:ppidunia/services/database.dart';
import 'package:ppidunia/services/notification.dart';

import 'package:ppidunia/common/helpers/unique_util.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';

enum InitFCMStatus { loading, loaded, error, idle }

class FirebaseProvider with ChangeNotifier {
  final FirebaseRepo fr;
  final InboxScreenModel ism;

  FirebaseProvider({required this.fr, required this.ism});

  InitFCMStatus _initFCMStatus = InitFCMStatus.idle;
  InitFCMStatus get initFCMStatus => _initFCMStatus;

  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  final soundpool = Soundpool.fromOptions(
    options: SoundpoolOptions.kDefault,
  );

  void setStateInitFCMStatus(InitFCMStatus initFCMStatus) {
    _initFCMStatus = initFCMStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    Map<String, dynamic> data = message.data;
    
    if (data != {}) {
      if (data["type"] != null) {
        await DBHelper.setAccountActive("accounts", data: {
          "id": 1,
          "status": "approval",
          "createdAt": DateTime.now().toIso8601String()
        });
      }
    }
    Soundpool soundpool = Soundpool.fromOptions(
      options: SoundpoolOptions.kDefault,
    );
    int soundId = await rootBundle
        .load(AssetsConst.audioNotifMpThree)
        .then((ByteData soundData) {
      return soundpool.load(soundData);
    });
    await soundpool.play(soundId);
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      
      if(message.data["type"] == "feed")
      {
        NS.push(navigatorKey.currentContext!, CommentScreen(feedId: message.data["feed_id"]));
      }else if(message.data["type"] == "feed_reply" || message.data["type"] == "feed_reply_mention") {
          NS.push(navigatorKey.currentContext!, CommentDetail(commentId: message.data["comment_id"]));
      }else{
        NS.push(
          navigatorKey.currentContext!,
          DetailInbox(
            type: message.data['type'],
            title: message.data['title'],
            name: message.data['name'],
            date: DateHelper.formatDateTime(message.data['date']),
            description:message.data['description'],
        ));
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  }

  Future<void> initFcm() async {
    setStateInitFCMStatus(InitFCMStatus.loading);
    try {
      await fr.initFcm(
        userId: SharedPrefs.getUserId(),
        lat: getCurrentLat.toString(),
        lng: getCurrentLng.toString(),
      );
      setStateInitFCMStatus(InitFCMStatus.loaded);
    } on CustomException catch (_) {
      setStateInitFCMStatus(InitFCMStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateInitFCMStatus(InitFCMStatus.error);
    }
  }

  void listenNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      int soundId = await rootBundle
          .load(AssetsConst.audioNotifMpThree)
          .then((ByteData soundData) {
        return soundpool.load(soundData);
      });
      await soundpool.play(soundId);
      Future.delayed(Duration.zero, () {
        ism.getInboxes();
      });
      var payload = {
        "title": message.data["title"],
        "feed_id": message.data["feed_id"],
        "comment_id": message.data["comment_id"],
        "name": message.data["name"],
        "date": message.data["date"],
        "type": message.data["type"],
        "description": message.data["description"],
      };
      
      NotificationService.showNotification(
        id: UniqueHelper.createUniqueId(),
        title: notification.title,
        body: notification.body,
        payload: json.encode(payload),
      );
    });
  }

  double get getCurrentLat => SharedPrefs.getLat();
  double get getCurrentLng => SharedPrefs.getLng();
}
