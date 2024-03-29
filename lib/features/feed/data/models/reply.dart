class ReplyDetailModel {
    int status;
    bool error;
    String message;
    PageDetail pageDetail;
    ReplyDetailData data;

    ReplyDetailModel({
        required this.status,
        required this.error,
        required this.message,
        required this.pageDetail,
        required this.data,
    });

    factory ReplyDetailModel.fromJson(Map<String, dynamic> json) => ReplyDetailModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        pageDetail: PageDetail.fromJson(json["pageDetail"]),
        data: ReplyDetailData.fromJson(json["data"]),
    );
}

class ReplyDetailData {
    String? uid;
    String? caption;
    List<dynamic>? media;
    User? user;
    FeedReplies? feedReplies;
    String? createdAt;

    ReplyDetailData({
        this.uid,
        this.caption,
        this.media,
        this.user,
        this.feedReplies,
        this.createdAt,
    });

    factory ReplyDetailData.fromJson(Map<String, dynamic> json) => ReplyDetailData(
        uid: json["uid"],
        caption: json["caption"],
        media: List<dynamic>.from(json["media"].map((x) => x)),
        user: User.fromJson(json["user"]),
        feedReplies: FeedReplies.fromJson(json["feed_replies"]),
        createdAt: json["created_at"],
    );
}

class FeedReplies {
    int total;
    List<Reply> replies;

    FeedReplies({
        required this.total,
        required this.replies,
    });

    factory FeedReplies.fromJson(Map<String, dynamic> json) => FeedReplies(
        total: json["total"],
        replies: List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
    );
}

class Reply {
    String uid;
    String reply;
    String createdAt;
    User user;
    List<Mentions> mentions;

    Reply({
        required this.uid,
        required this.reply,
        required this.createdAt,
        required this.user,
        required this.mentions,
    });

    factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        uid: json["uid"],
        reply: json["reply"],
        createdAt: json["created_at"],
        user: User.fromJson(json["user"]),
        mentions: List<Mentions>.from(json["mentions"].map((x) => Mentions.fromJson(x))),
    );
}

class Mentions {
    String id;
    String name;
    String reply;

    Mentions({
        required this.id,
        required this.name,
        required this.reply,
    });

    factory Mentions.fromJson(Map<String, dynamic> json) => Mentions(
        id: json["id"],
        name: json["name"],
        reply: json["reply"],
    );
}

class User {
    String uid;
    String avatar;
    String username;
    String name;

    User({
        required this.uid,
        required this.avatar,
        required this.username,
        required this.name,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        avatar: json["avatar"],
        username: json["username"],
        name: json["name"],
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