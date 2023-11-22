import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ppidunia/utils/exceptions.dart';
import 'package:ppidunia/utils/shared_preferences.dart';

import 'package:ppidunia/data/models/feed/feed.dart';

import 'package:ppidunia/data/repository/feed/feed.dart';
import 'package:ppidunia/data/repository/bookmark/bookmark.dart';

enum BookmarkStatus { idle, loading, loaded, empty, error }

class BookmarkScreenModel with ChangeNotifier {
  BookmarkRepo br;
  FeedRepo fr;

  BookmarkScreenModel({
    required this.br,
    required this.fr
  });

  bool hasMore = true;
  int pageKey = 1;
  
  Timer? debounce;

  late TextEditingController searchC;

  String progress = "";

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  String search = '';

  List<FeedData> _feeds = [];
  List<FeedData> get feeds => [..._feeds];

  BookmarkStatus _bookmarkStatus = BookmarkStatus.loading;
  BookmarkStatus get bookmarkStatus => _bookmarkStatus;

  void setStateBookmarkStatus(BookmarkStatus bookmarkStatus) {
    _bookmarkStatus = bookmarkStatus;
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

  Future<void> loadMoreFeed() async {
    pageKey++;
    FeedModel fm = await br.getFeeds(
      pageKey: pageKey,
      search: search
    );
    hasMore = fm.pageDetail.hasMore;
    _feeds.addAll(fm.data);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getFeeds() async {
    
    pageKey = 1;
    hasMore = true;

    try {
      FeedModel fm = await br.getFeeds(
        pageKey: pageKey,
        search: search
      );
      _feeds = [];
      _feeds.addAll(fm.data);
      setStateBookmarkStatus(BookmarkStatus.loaded);
      
      if(feeds.isEmpty) {
        setStateBookmarkStatus(BookmarkStatus.empty);
      }
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateBookmarkStatus(BookmarkStatus.error);
    } catch(_) {
      setStateBookmarkStatus(BookmarkStatus.error);
    }
  }

  Future<void> toggleLike({required String feedId, required FeedLikes feedLikes}) async {
    try {
      int idxLikes = feedLikes.likes.indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if(idxLikes != -1) {
        feedLikes.likes.removeAt(idxLikes);
        feedLikes.total = feedLikes.total - 1; 
      } else {
        feedLikes.likes.add(
          UserLikes(
            user: User(
              uid: SharedPrefs.getUserId(),
              avatar: "-", 
              name: "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}"
            )
          )
        );
        feedLikes.total = feedLikes.total + 1; 
      }
      await fr.toggleLike(feedId: feedId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

  Future<void> toggleBookmark({required String feedId, required FeedBookmarks feedBookmarks}) async {
    try {
      int idxBookmarks = feedBookmarks.bookmarks.indexWhere((el) => el.user.uid == SharedPrefs.getUserId());
      if(idxBookmarks != -1) {
        feedBookmarks.bookmarks.removeAt(idxBookmarks);
        feedBookmarks.total = feedBookmarks.total - 1; 
      } else {
        feedBookmarks.bookmarks.add(
          UserLikes(
            user: User(
              uid: SharedPrefs.getUserId(),
              avatar: "-", 
              name: "${SharedPrefs.getRegFistName()} ${SharedPrefs.getRegLastName()}"
            )
          )
        );
        feedBookmarks.total = feedBookmarks.total + 1; 
      }
      await fr.toggleBookmark(feedId: feedId);
      getFeeds();
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

  Future<void> delete({required String feedId}) async {
    try {
      await fr.feedDelete(feedId: feedId);
      getFeeds();
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

}