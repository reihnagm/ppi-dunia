
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:dio/dio.dart';

import 'package:path/path.dart' as b;

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:ppidunia/providers/profile/profile.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';

import 'package:ppidunia/data/models/feed/detail.dart';
import 'package:ppidunia/data/repository/feed/comment/comment.dart';
import 'package:ppidunia/data/repository/feed/feed.dart';

import 'package:ppidunia/utils/shared_preferences.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/exceptions.dart';

enum FeedDetailStatus { idle, loading, loaded, empty, error }
enum CommentStatus { idle, loading, loaded, empty, error }

class CommentScreenModel with ChangeNotifier {
  CommentRepo cr;
  FeedRepo fr;
  ProfileProvider pp;

  CommentScreenModel({
    required this.cr,
    required this.fr,
    required this.pp
  });

  String progress = "";

  bool hasMore = true;
  int pageKey = 1;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  late CarouselController carouselC;
  late TextEditingController commentC;
  late ScrollController sc;
  
  FeedDetailData _feedDetailData = FeedDetailData();
  FeedDetailData get feedDetailData => _feedDetailData;

  final List<Comment> _comments = [];
  List<Comment> get comments => [..._comments];

  FeedDetailStatus _feedDetailStatus = FeedDetailStatus.loading;
  FeedDetailStatus get feedDetailStatus => _feedDetailStatus;

  CommentStatus _commentStatus = CommentStatus.loading; 
  CommentStatus get commentStatus => _commentStatus;

  void onChangeCurrentMultipleImg(int i) {
    currentIndexMultipleImg = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedDetailStatus(FeedDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCommentStatus(CommentStatus commentStatus) {
    _commentStatus = commentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> post({required String feedId}) async {
    try {
      if(commentC.text.trim() == "") {
        return;
      }

      await cr.post(
        feedId: feedId, 
        comment: commentC.text
      );

      FeedDetailModel fdm = await cr.getFeedDetail(feedId: feedId, pageKey: 1);
      _feedDetailData = fdm.data;

      _comments.clear();
      _comments.addAll(fdm.data.feedComments!.comments);

      commentC.text = "";

      setStateCommentStatus(CommentStatus.loaded);
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

  Future<void> loadMoreComment({required String feedId}) async {
    pageKey++;
    FeedDetailModel fdm = await cr.getFeedDetail(feedId: feedId, pageKey: pageKey);
    hasMore = fdm.commentPaginate.hasMore;
    _comments.addAll(fdm.data.feedComments!.comments);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getFeedDetail({
    required String feedId
  }) async {
      
    pageKey = 1;
    hasMore = true;

    try {
      FeedDetailModel fdm = await cr.getFeedDetail(feedId: feedId, pageKey: pageKey);
      _feedDetailData = fdm.data;

      _comments.clear();
      _comments.addAll(fdm.data.feedComments!.comments);
      setStateFeedDetailStatus(FeedDetailStatus.loaded);
      setStateCommentStatus(CommentStatus.loaded);

      if(comments.isEmpty) {
        setStateCommentStatus(CommentStatus.empty);
      }
    } on CustomException catch(e) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
      debugPrint(e.toString());
    } catch(_) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
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
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch(e) {
      debugPrint(e.toString());
    } catch(_) {}
  }

  Future<void> downloadDoc(BuildContext context, String url) async {
    Directory documentsIos = await getApplicationDocumentsDirectory();
    String? saveDir = Platform.isIOS 
    ? documentsIos.path 
    : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOCUMENTS);
    ProgressDialog pr = ProgressDialog(context: context);
    try {
      Dio dio = Dio();
      String ext = b.basename(url).split('.').last;
      String name = b.basename(url).split('.').first;
      String filename = "$name-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${Random().nextInt(100000)}.$ext";
      pr.show(
        msgTextAlign: TextAlign.start,
        msgMaxLines: 1,
        backgroundColor: ColorResources.greyDarkPrimary,
        msgColor: ColorResources.greyLight,
        msg: '${getTranslated("PLEASE_WAIT")} $progress',
        progressBgColor: ColorResources.greyLight,
        progressValueColor: ColorResources.greyDarkPrimary
      );
      await dio.download(url, "$saveDir/$filename",
        onReceiveProgress: (int count, int total) {
          progress = ((count / total) * 100).toStringAsFixed(0);
        },
      );  
      pr.close();
      // ignore: use_build_context_synchronously
      ShowSnackbar.snackbar(context, "File saved to $saveDir/${b.basename(url)}", "", ColorResources.success);
    } catch(e) {
      debugPrint(e.toString());
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

}