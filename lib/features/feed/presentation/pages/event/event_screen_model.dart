import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/features/feed/data/models/event.dart';
import 'package:ppidunia/features/feed/data/reposiotories/event.dart';

enum EventStatus { idle, loading, loaded, empty, error }

class EventScreenModel with ChangeNotifier {
  EventRepo er;

  EventScreenModel({required this.er});

  String progress = "";

  bool hasMore = true;
  int pageKey = 1;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  late CarouselController carouselC;
  late TextEditingController commentC;
  late TextEditingController replyC;
  late ScrollController sc;

  List<EventData> _event = [];
  List<EventData> get event => [..._event];

  EventStatus _eventStatus = EventStatus.loading;
  EventStatus get eventStatus => _eventStatus;

  void setStateEventStatus(EventStatus eventStatus) {
    _eventStatus = eventStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getEvent() async {
    pageKey = 1;
    hasMore = true;

    try {
      EventModel em = await er.getEvent();

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

  // Future<void> loadMoreComment({required String feedId}) async {
  //   pageKey++;
  //   EventModel em = await er.getEvent();
  //   hasMore = em.commentPaginate.hasMore;
  //   _event.addAll(em.data.feedComments!.comments);
  //   Future.delayed(Duration.zero, () => notifyListeners());
  // }
}
