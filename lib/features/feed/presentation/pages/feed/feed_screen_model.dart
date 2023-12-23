import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ppidunia/features/country/data/models/branch.dart';
import 'package:ppidunia/features/feed/data/models/feed.dart';
import 'package:ppidunia/features/feed/data/reposiotories/feed.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/errors/exceptions.dart';

enum FeedStatus { idle, loading, loaded, empty, error }

enum GetBranchStatus { idle, loading, loaded, empty, error }

class FeedScreenModel with ChangeNotifier {
  FeedRepo fr;

  FeedScreenModel({required this.fr});

  Timer? debounce;

  bool hasMore = true;
  int pageKey = 1;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  int selectedVarTag = 0;

  // bool isLocationServiceEnabled = false;

  late TextEditingController searchC;
  late ScrollController countriesC;

  PanelController panelC = PanelController();
  late ScrollController sc;

  String branch = '';
  String search = '';

  GetBranchStatus _getBranchStatus = GetBranchStatus.idle;
  GetBranchStatus get getBranchStatus => _getBranchStatus;

  FeedStatus _feedStatus = FeedStatus.loading;
  FeedStatus get feedStatus => _feedStatus;

  List<BranchData> _branches = [];
  List<BranchData> get branches => [..._branches];

  List<FeedData> _feeds = [];
  List<FeedData> get feeds => [..._feeds];

  void setStateGetBranchStatus(GetBranchStatus getBranchStatus) {
    _getBranchStatus = getBranchStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedStatus(FeedStatus feedStatus) {
    _feedStatus = feedStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeCurrentMultipleImg(int i) {
    currentIndexMultipleImg = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeSearch(String searchParam) {
    search = searchParam;
    getFeeds();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void selectedTag(String branchParam, int i) {
    selectedVarTag = i;
    if (branchParam.toLowerCase() == 'all') {
      branch = '';
    } else {
      branch = branchParam;
    }
    getFeeds();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeBanner(int i) {
    currentIndex = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // Future<void> listenForPermissionStatus() async {
  //   lp.ServiceStatus serviceStatus = await lp.LocationPermissions().checkServiceStatus();
  //   if (serviceStatus == lp.ServiceStatus.enabled) {
  //     isLocationServiceEnabled = true;
  //     Future.delayed(Duration.zero, () => notifyListeners());
  //   }
  // }

  Future<void> getFeedTag() async {
    setStateGetBranchStatus(GetBranchStatus.loading);
    try {
      _branches.add(BranchData(
          uid: '5762f643-ba53-4ddd-bb4d-ccf319678de3', branch: 'All'));
      BranchModel bm = await fr.getFeedTag();
      _branches = [];
      _branches.addAll(bm.data);
      setStateGetBranchStatus(GetBranchStatus.loaded);
      if (branches.isEmpty) {
        setStateGetBranchStatus(GetBranchStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateGetBranchStatus(GetBranchStatus.error);
    } catch (_) {
      setStateGetBranchStatus(GetBranchStatus.error);
    }
  }

  Future<void> getLocation() async {
    // Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // SharedPrefs.writeLatLng(p.latitude, p.longitude);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> loadMoreFeed() async {
    pageKey++;
    FeedModel fm =
        await fr.getFeeds(pageKey: pageKey, branch: branch, search: search);
    hasMore = fm.pageDetail.hasMore;
    _feeds.addAll(fm.data);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getFeeds() async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedModel fm =
          await fr.getFeeds(pageKey: pageKey, branch: branch, search: search);
      _feeds = [];
      _feeds.addAll(fm.data);
      setStateFeedStatus(FeedStatus.loaded);

      if (feeds.isEmpty) {
        setStateFeedStatus(FeedStatus.empty);
      }
    } on CustomException catch (e) {
      debugPrint(e.toString());
      setStateFeedStatus(FeedStatus.error);
    } catch (_) {
      setStateFeedStatus(FeedStatus.error);
    }
  }

  Future<void> toggleLike(
      {required String feedId, required FeedLikes feedLikes}) async {
    try {
      int idxLikes = feedLikes.likes
          .indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if (idxLikes != -1) {
        feedLikes.likes.removeAt(idxLikes);
        feedLikes.total = feedLikes.total - 1;
      } else {
        feedLikes.likes.add(UserLikes(
            user: User(
                uid: SharedPrefs.getUserId(),
                avatar: "-",
                name:
                    "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}")));
        feedLikes.total = feedLikes.total + 1;
      }
      await fr.toggleLike(feedId: feedId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> toggleBookmark(
      {required String feedId, required FeedBookmarks feedBookmarks}) async {
    try {
      int idxBookmarks = feedBookmarks.bookmarks
          .indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if (idxBookmarks != -1) {
        feedBookmarks.bookmarks.removeAt(idxBookmarks);
        feedBookmarks.total = feedBookmarks.total - 1;
      } else {
        feedBookmarks.bookmarks.add(UserLikes(
            user: User(
                uid: SharedPrefs.getUserId(),
                avatar: "-",
                name:
                    "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}")));
        feedBookmarks.total = feedBookmarks.total + 1;
      }
      await fr.toggleBookmark(feedId: feedId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> delete({required String feedId}) async {
    try {
      await fr.feedDelete(feedId: feedId);
      getFeeds();
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }
}
