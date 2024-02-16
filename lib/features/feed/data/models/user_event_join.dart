class JoinedEventModel {
    int status;
    bool error;
    String message;
    PageDetail pageDetail;
    List<JoinedEventData> data;

    JoinedEventModel({
        required this.status,
        required this.error,
        required this.message,
        required this.pageDetail,
        required this.data,
    });

    factory JoinedEventModel.fromJson(Map<String, dynamic> json) => JoinedEventModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        pageDetail: PageDetail.fromJson(json["pageDetail"]),
        data: List<JoinedEventData>.from(json["data"].map((x) => JoinedEventData.fromJson(x))),
    );
}

class JoinedEventData {
    String? id;
    String? picture;
    String? title;
    String? description;
    String? location;
    String? start;
    String? end;
    bool? isExpired;
    String? startDate;
    String? endDate;
    bool? joined;

    JoinedEventData({
        this.id,
        this.picture,
        this.title,
        this.description,
        this.location,
        this.start,
        this.end,
        this.isExpired,
        this.startDate,
        this.endDate,
        this.joined,
    });

    factory JoinedEventData.fromJson(Map<String, dynamic> json) => JoinedEventData(
        id: json["id"],
        picture: json["picture"],
        title: json["title"],
        description: json["description"],
        location: json["location"],
        start: json["start"],
        end: json["end"],
        isExpired: json["is_expired"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        joined: json["joined"],
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
