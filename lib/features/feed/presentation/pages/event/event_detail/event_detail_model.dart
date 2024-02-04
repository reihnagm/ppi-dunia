import 'package:flutter/material.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/features/feed/data/models/event_detail.dart';
import 'package:ppidunia/features/feed/data/reposiotories/event.dart';

enum EventDetailStatus { idle, loading, loaded, empty, error }

class EventDetailScreenModel with ChangeNotifier {
  EventRepo er;

  EventDetailScreenModel({required this.er});

  String progress = "";

  bool hasMore = true;
  int pageKey = 1;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  EventDetailData _eventDetailData = EventDetailData();
  EventDetailData get eventDetailData => _eventDetailData;

  EventDetailStatus _eventDetailStatus = EventDetailStatus.loading;
  EventDetailStatus get eventDetailStatus => _eventDetailStatus;

  void setStateEventDetailStatus(EventDetailStatus eventDetailStatus) {
    _eventDetailStatus = eventDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getEventData({required String idEvent}) async {
    try {
      EventDetailModel? edm = await er.getDetailEvent(idEvent: idEvent);
      _eventDetailData = edm!.data;
      setStateEventDetailStatus(EventDetailStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateEventDetailStatus(EventDetailStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateEventDetailStatus(EventDetailStatus.error);
    }
  }
}
