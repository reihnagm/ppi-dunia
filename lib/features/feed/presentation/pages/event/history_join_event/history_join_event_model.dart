import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/features/feed/data/models/user_event_join.dart';
import 'package:ppidunia/features/feed/data/reposiotories/event.dart';

enum JoinedEventStatus { idle, loading, loaded, empty, error }

class JoinedEventScreenModel with ChangeNotifier {
  EventRepo er;

  JoinedEventScreenModel({required this.er});

  List<JoinedEventData> _eventJoined = [];
  List<JoinedEventData> get eventJoined => [..._eventJoined];

  JoinedEventStatus _eventJoinStatus = JoinedEventStatus.loading;
  JoinedEventStatus get eventJoinStatus => _eventJoinStatus;

  void setStateEventJoinStatus(JoinedEventStatus eventJoinStatus) {
    _eventJoinStatus = eventJoinStatus;
    notifyListeners();
  }

  Future<void> getEventJoined() async {
    try {
      JoinedEventModel ejm = await er.getEventJoined();

      _eventJoined = [];
      _eventJoined.addAll(ejm.data);
      setStateEventJoinStatus(JoinedEventStatus.loaded);

      if (eventJoined.isEmpty) {
        setStateEventJoinStatus(JoinedEventStatus.empty);
      }
    } on CustomException catch (_) {
      setStateEventJoinStatus(JoinedEventStatus.error);
    } catch (_) {
      setStateEventJoinStatus(JoinedEventStatus.error);
    }
  }
}
