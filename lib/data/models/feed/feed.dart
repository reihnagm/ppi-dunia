class FeedModel {
  int status;
  bool error;
  String message;
  PageDetail pageDetail;
  List<FeedData> data;

  FeedModel({
    required this.status,
    required this.error,
    required this.message,
    required this.pageDetail,
    required this.data,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    pageDetail: PageDetail.fromJson(json["pageDetail"]),
    data: List<FeedData>.from(json["data"].map((x) => FeedData.fromJson(x))),
  );
}

class FeedData {
  String uid;
  String caption;
  List<Media> media;
  User user;
  FeedComments feedComments;
  FeedLikes feedLikes;
  FeedBookmarks feedBookmarks;
  CountryModel country;
  String feedType;
  String createdAt;

  FeedData({
    required this.uid,
    required this.caption,
    required this.media,
    required this.user,
    required this.feedComments,
    required this.feedLikes,
    required this.feedBookmarks,
    required this.country,
    required this.feedType,
    required this.createdAt,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
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

class CountryModel {
  String branch;

  CountryModel({
    required this.branch,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    branch: json["branch"],
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
  CommentLikes commentLikes;
  CommentReplies commentReplies;
  User user;

  Comment({
    required this.uid,
    required this.comment,
    required this.commentLikes,
    required this.commentReplies,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    uid: json["uid"],
    comment: json["comment"],
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
    likes: List<CommentLikesLike>.from(json["likes"].map((x) => CommentLikesLike.fromJson(x))),
  );
}

class CommentLikesLike {
  String uid;
  User user;

  CommentLikesLike({
    required this.uid,
    required this.user,
  });

  factory CommentLikesLike.fromJson(Map<String, dynamic> json) => CommentLikesLike(
    uid: json["uid"],
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
    replies: List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
  );
}

class Reply {
  String uid;
  String reply;
  User user;

  Reply({
    required this.uid,
    required this.reply,
    required this.user,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    uid: json["uid"],
    reply: json["reply"],
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
    likes: List<UserLikes>.from(json["likes"].map((x) => UserLikes.fromJson(x))),
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
    bookmarks: List<UserLikes>.from(json["bookmarks"].map((x) => UserLikes.fromJson(x))),
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

class Media {
  String path;
  String size;

  Media({
    required this.path,
    required this.size
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    path: json["path"],
    size: json["size"]
  );
}

class PageDetail {
  bool hasMore;
  int total;
  int perPage;
  int nextPage;
  int prevPage;
  int currentPage;
  String nextUrl;
  String prevUrl;

  PageDetail({
    required this.hasMore,
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.prevPage,
    required this.currentPage,
    required this.nextUrl,
    required this.prevUrl,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
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