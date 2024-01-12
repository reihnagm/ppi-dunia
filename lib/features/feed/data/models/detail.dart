class FeedDetailModel {
  int status;
  bool error;
  String message;
  CommentPaginateModel commentPaginate;
  FeedDetailData data;

  FeedDetailModel({
    required this.status,
    required this.error,
    required this.message,
    required this.commentPaginate,
    required this.data,
  });

  factory FeedDetailModel.fromJson(Map<String, dynamic> json) =>
      FeedDetailModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        commentPaginate:
            CommentPaginateModel.fromJson(json["comment_paginate"]),
        data: FeedDetailData.fromJson(json["data"]),
      );
}

class CommentPaginateModel {
  bool hasMore;
  int total;
  int perPage;
  int nextPage;
  int prevPage;
  int currentPage;
  String nextUrl;
  String prevUrl;

  CommentPaginateModel({
    required this.hasMore,
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.prevPage,
    required this.currentPage,
    required this.nextUrl,
    required this.prevUrl,
  });

  factory CommentPaginateModel.fromJson(Map<String, dynamic> json) =>
      CommentPaginateModel(
        hasMore: json["has_more"],
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
      );
}

class FeedDetailData {
  String? uid;
  String? caption;
  List<Media>? media;
  User? user;
  FeedComments? feedComments;
  FeedLikes? feedLikes;
  FeedBookmarks? feedBookmarks;
  CountryModel? country;
  String? feedType;
  String? createdAt;

  FeedDetailData({
    this.uid,
    this.caption,
    this.media,
    this.user,
    this.feedComments,
    this.feedLikes,
    this.feedBookmarks,
    this.country,
    this.feedType,
    this.createdAt,
  });

  factory FeedDetailData.fromJson(Map<String, dynamic> json) => FeedDetailData(
        uid: json["uid"],
        caption: json["caption"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        user: User.fromJson(json["user"]),
        feedComments: FeedComments.fromJson(json["feed_comments"]),
        feedLikes: FeedLikes.fromJson(json["feed_likes"]),
        feedBookmarks: FeedBookmarks.fromJson(json["feed_bookmarks"]),
        country: CountryModel.fromJson(json["country"]),
        feedType: json["feed_type"],
        createdAt: json["created_at"],
      );
}

class Media {
  String path;
  String size;

  Media({required this.path, required this.size});

  factory Media.fromJson(Map<String, dynamic> json) =>
      Media(path: json["path"], size: json["size"]);
}

class CountryModel {
  String branch;

  CountryModel({
    required this.branch,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        branch: json["branch"],
      );
}

class FeedBookmarks {
  int total;
  List<UserLikes> bookmarks;

  FeedBookmarks({
    required this.total,
    required this.bookmarks,
  });

  factory FeedBookmarks.fromJson(Map<String, dynamic> json) => FeedBookmarks(
        total: json["total"],
        bookmarks: List<UserLikes>.from(
            json["bookmarks"].map((x) => UserLikes.fromJson(x))),
      );
}

class FeedComments {
  int total;
  List<Comment> comments;

  FeedComments({
    required this.total,
    required this.comments,
  });

  factory FeedComments.fromJson(Map<String, dynamic> json) => FeedComments(
        total: json["total"],
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
      );
}

class Comment {
  String uid;
  String comment;
  String createdAt;
  CommentLikes commentLikes;
  CommentReplies commentReplies;
  User user;

  Comment({
    required this.uid,
    required this.comment,
    required this.createdAt,
    required this.commentLikes,
    required this.commentReplies,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        uid: json["uid"],
        comment: json["comment"],
        createdAt: json["created_at"],
        commentLikes: CommentLikes.fromJson(json["comment_likes"]),
        commentReplies: CommentReplies.fromJson(json["comment_replies"]),
        user: User.fromJson(json["user"]),
      );
}

class CommentLikes {
  int total;
  List<CommentLikesLike> likes;

  CommentLikes({
    required this.total,
    required this.likes,
  });

  factory CommentLikes.fromJson(Map<String, dynamic> json) => CommentLikes(
        total: json["total"],
        likes: List<CommentLikesLike>.from(
            json["likes"].map((x) => CommentLikesLike.fromJson(x))),
      );
}

class CommentLikesLike {
  String uid;
  User user;

  CommentLikesLike({
    required this.uid,
    required this.user,
  });

  factory CommentLikesLike.fromJson(Map<String, dynamic> json) =>
      CommentLikesLike(
        uid: json["uid"],
        user: User.fromJson(json["user"]),
      );
}

class FeedLikes {
  int total;
  List<UserLikes> likes;

  FeedLikes({
    required this.total,
    required this.likes,
  });

  factory FeedLikes.fromJson(Map<String, dynamic> json) => FeedLikes(
        total: json["total"],
        likes: List<UserLikes>.from(
            json["likes"].map((x) => UserLikes.fromJson(x))),
      );
}

class UserLikes {
  User user;

  UserLikes({
    required this.user,
  });

  factory UserLikes.fromJson(Map<String, dynamic> json) => UserLikes(
        user: User.fromJson(json["user"]),
      );
}

class User {
  String uid;
  String avatar;
  String name;

  User({
    required this.uid,
    required this.avatar,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        avatar: json["avatar"],
        name: json["name"],
      );
}

class CommentReplies {
  int total;
  List<Reply> replies;

  CommentReplies({
    required this.total,
    required this.replies,
  });

  factory CommentReplies.fromJson(Map<String, dynamic> json) => CommentReplies(
        total: json["total"],
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
      );
}

class Reply {
  String uid;
  String reply;
  String createdAt;
  User user;

  Reply({
    required this.uid,
    required this.reply,
    required this.createdAt,
    required this.user,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        uid: json["uid"],
        reply: json["reply"],
        createdAt: json["created_at"],
        user: User.fromJson(json["user"]),
      );
}
