import 'package:flutter/material.dart';

import 'package:ppidunia/features/inbox/data/models/count.dart';
import 'package:ppidunia/features/inbox/data/models/inbox.dart';

import 'package:ppidunia/features/inbox/data/repositories/inbox.dart';

import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';

enum InboxStatus { idle, loading, loaded, empty, error }

enum InboxCountStatus { idle, loading, loaded, empty, error }

class InboxScreenModel with ChangeNotifier {
  InboxRepo ir;

  InboxScreenModel({required this.ir});

  int pageKey = 0;

  List<InboxData> _id = [];
  List<InboxData> get id => [..._id];

  InboxStatus _inboxStatus = InboxStatus.idle;
  InboxStatus get inboxStatus => _inboxStatus;

  InboxCountStatus _inboxCountStatus = InboxCountStatus.idle;
  InboxCountStatus get inboxCountStatus => _inboxCountStatus;

  int _readCount = 0;
  int get readCount => _readCount;

  void setStateInboxCountStatus(InboxCountStatus inboxCountStatus) {
    _inboxCountStatus = inboxCountStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInboxStatus(InboxStatus inboxStatus) {
    _inboxStatus = inboxStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> loadMoreInbox() async {
    pageKey++;
    InboxModel im = await ir.getInbox(
        pageKey: pageKey, type: "sos", userId: SharedPrefs.getUserId());
    _id.addAll(im.data!);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getInboxes() async {
    pageKey = 1;

    try {
      InboxModel im = await ir.getInbox(
          pageKey: pageKey, type: "sos", userId: SharedPrefs.getUserId());
      _id = [];
      _id.addAll(im.data!);
      setStateInboxStatus(InboxStatus.loaded);

      if (id.isEmpty) {
        setStateInboxStatus(InboxStatus.empty);
      }

      getReadCount();
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateInboxStatus(InboxStatus.error);
    } catch (_) {
      setStateInboxStatus(InboxStatus.error);
    }
  }

  Future<void> getInboxesBroadcast() async {
    pageKey = 1;

    try {
      InboxModel im = await ir.getInbox(
          pageKey: pageKey, type: "default", userId: SharedPrefs.getUserId());
      _id = [];
      _id.addAll(im.data!);
      setStateInboxStatus(InboxStatus.loaded);

      if (id.isEmpty) {
        setStateInboxStatus(InboxStatus.empty);
      }

      getReadCount();
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateInboxStatus(InboxStatus.error);
    } catch (_) {
      setStateInboxStatus(InboxStatus.error);
    }
  }

  Future<void> inboxDetail({required String inboxId}) async {
    try {
      await ir.updateInbox(inboxId: inboxId, userId: SharedPrefs.getUserId());
      getReadCount();
      getInboxes();
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> getReadCount() async {
    setStateInboxCountStatus(InboxCountStatus.loading);
    try {
      InboxCountModel icm =
          await ir.getInboxCount(userId: SharedPrefs.getUserId());
      int icmCount = icm.data!.total!;
      _readCount = icmCount;
      setStateInboxCountStatus(InboxCountStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateInboxCountStatus(InboxCountStatus.error);
    } catch (_) {
      setStateInboxCountStatus(InboxCountStatus.error);
    }
  }
}
