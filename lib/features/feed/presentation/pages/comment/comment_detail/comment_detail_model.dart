import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/features/feed/data/models/reply.dart';
import 'package:ppidunia/features/feed/data/reposiotories/comment/reply.dart';
import 'package:ppidunia/features/feed/data/reposiotories/feed.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

enum ReplyDetailStatus { idle, loading, loaded, empty, error }

enum ReplyStatus { idle, loading, loaded, empty, error }

class CommentDetailModel with ChangeNotifier {
  ReplyRepo rr;
  FeedRepo fr;
  ProfileProvider pp;

  CommentDetailModel({required this.rr, required this.fr, required this.pp});

  String progress = "";

  bool hasMore = true;
  int pageKey = 1;

  int currentIndexMultipleImg = 0;
  int currentIndex = 0;

  late CarouselController carouselC;
  late TextEditingController commentC;
  late TextEditingController replyC;
  late ScrollController sc;

  ReplyDetailData _replyDetailData = ReplyDetailData();
  ReplyDetailData get replyDetailData => _replyDetailData;

  final List<Reply> _reply = [];
  List<Reply> get reply => [..._reply];

  ReplyDetailStatus _feedDetailStatus = ReplyDetailStatus.loading;
  ReplyDetailStatus get feedDetailStatus => _feedDetailStatus;

  ReplyStatus _replyStatus = ReplyStatus.loading;
  ReplyStatus get replyStatus => _replyStatus;

  void onChangeCurrentMultipleImg(int i) {
    currentIndexMultipleImg = i;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedDetailStatus(ReplyDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateReplyStatus(ReplyStatus replyStatus) {
    _replyStatus = replyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getReplyDetail({required String commentId}) async {
    pageKey = 1;
    hasMore = true;

    try {
      ReplyDetailModel rdm = await rr.getReplyDetail(commentId: commentId, pageKey: pageKey);
      _replyDetailData = rdm.data;

      _reply.clear();
      _reply.addAll(replyDetailData.feedReplies!.replies);
      setStateFeedDetailStatus(ReplyDetailStatus.loaded);
      setStateReplyStatus(ReplyStatus.loaded);

      if (reply.isEmpty) {
        setStateReplyStatus(ReplyStatus.empty);
      }
    } on CustomException catch (_) {
      setStateFeedDetailStatus(ReplyDetailStatus.error);
    } catch (_) {
      setStateFeedDetailStatus(ReplyDetailStatus.error);
    }
  }

  Future<void> postReplyMention({
    required feedId,
    required String commentId,
    required String reply,
  }) async {
    try {
      if (reply.trim() == "") {
        return;
      }

      if (!reply.contains('@')) {
        await rr.postReply(
          feedId: feedId,
          reply: reply,
          commentId: commentId,
        );
      } else {
        await rr.postReplyMention(
          feedId: feedId,
          reply: reply,
          commentId: commentId,
        );
      }

      ReplyDetailModel rdm = await rr.getReplyDetail(
        commentId: commentId, 
        pageKey: 1
      );
      
      _replyDetailData = rdm.data;

      _reply.clear();
      _reply.addAll(rdm.data.feedReplies!.replies);

      setStateFeedDetailStatus(ReplyDetailStatus.loaded);
      setStateReplyStatus(ReplyStatus.loaded);
    } on CustomException catch (_) {
      setStateFeedDetailStatus(ReplyDetailStatus.error);
      setStateReplyStatus(ReplyStatus.error);
    }
  }

  Future<void> deleteReply(
      {required String commentId, required String deleteId}) async {
    try {
      await rr.deleteReply(deleteId: deleteId);

      ReplyDetailModel rdm =
          await rr.getReplyDetail(commentId: commentId, pageKey: 1);
      _replyDetailData = rdm.data;

      _reply.clear();
      _reply.addAll(rdm.data.feedReplies!.replies);

      setStateFeedDetailStatus(ReplyDetailStatus.loaded);
      setStateReplyStatus(ReplyStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> loadMoreReply({required String commentId}) async {
    pageKey++;
    ReplyDetailModel rdm =
        await rr.getReplyDetail(commentId: commentId, pageKey: pageKey);
    hasMore = rdm.pageDetail.hasMore;
    _reply.addAll(rdm.data.feedReplies!.replies);
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
