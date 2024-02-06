import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/features/feed/data/models/event.dart';
import 'package:ppidunia/features/feed/data/models/user_event_join.dart';
import 'package:ppidunia/features/feed/data/reposiotories/event.dart';

enum EventStatus { idle, loading, loaded, empty, error }

class EventScreenModel with ChangeNotifier {
  EventRepo er;

  EventScreenModel({required this.er});

  Timer? debounce;

  String progress = "";
  String branch = '';
  String search = '';

  bool hasMore = true;
  int pageKey = 1;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  late CarouselController carouselC;
  late TextEditingController commentC;
  late TextEditingController replyC;
  late ScrollController sc;
  
  late TextEditingController searchC;

  List<EventData> _event = [];
  List<EventData> get event => [..._event];
  List<JoinedEventData> _eventJoined = [];
  List<JoinedEventData> get eventJoined => [..._eventJoined];

  EventStatus _eventStatus = EventStatus.loading;
  EventStatus get eventStatus => _eventStatus;

  void setStateEventStatus(EventStatus eventStatus) {
    _eventStatus = eventStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  void setStateEventJoinStatus(EventStatus eventStatus) {
    _eventStatus = eventStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeSearch(String searchParam) {
    search = searchParam;
    getEvent();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getEvent() async {
    pageKey = 1;
    hasMore = true;

    try {
      EventModel em = await er.getEvent(pageKey: pageKey, branch: branch, search: search);

      _event = [];
      _event.addAll(em.data);
      setStateEventStatus(EventStatus.loaded);

      if (event.isEmpty) {
        setStateEventStatus(EventStatus.empty);
      }
    } on CustomException catch (_) {
      setStateEventStatus(EventStatus.error);
    } catch (_) {
      setStateEventStatus(EventStatus.error);
    }
  }

  Future<void> getEventJoined() async {
    pageKey = 1;
    hasMore = true;

    try {
      JoinedEventModel ejm = await er.getEventJoined();

      _eventJoined = [];
      _eventJoined.addAll(ejm.data);
      setStateEventJoinStatus(EventStatus.loaded);

      if (eventJoined.isEmpty) {
        setStateEventJoinStatus(EventStatus.empty);
      }
    } on CustomException catch (_) {
      setStateEventJoinStatus(EventStatus.error);
    } catch (_) {
      setStateEventJoinStatus(EventStatus.error);
    }
  }

  Future<void> loadMoreEvent() async {
    pageKey++;
    EventModel em = await er.getEvent(pageKey: pageKey, branch: branch, search: search);
    hasMore = em.pageDetail.hasMore;
    _event.addAll(em.data);
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
