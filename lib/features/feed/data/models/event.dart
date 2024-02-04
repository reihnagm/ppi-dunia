class EventModel {
    int status;
    bool error;
    String message;
    PageDetail pageDetail;
    List<EventData> data;

    EventModel({
        required this.status,
        required this.error,
        required this.message,
        required this.pageDetail,
        required this.data,
    });

    factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        pageDetail: PageDetail.fromJson(json["pageDetail"]),
        data: List<EventData>.from(json["data"].map((x) => EventData.fromJson(x))),
    );
}

class EventData {
    String? id;
    String? picture;
    String? title;
    String? description;
    String? date;
    bool? paid;
    String? location;
    String? start;
    String? end;
    bool? joined;

    EventData({
        this.id,
        this.picture,
        this.title,
        this.description,
        this.date,
        this.paid,
        this.location,
        this.start,
        this.end,
        this.joined,
    });

    factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        id: json["id"],
        picture: json["picture"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        paid: json["paid"],
        location: json["location"],
        start: json["start"],
        end: json["end"],
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

    Map<String, dynamic> toJson() => {
        "has_more": hasMore,
        "total": total,
        "per_page": perPage,
        "next_page": nextPage,
        "prev_page": prevPage,
        "current_page": currentPage,
        "next_url": nextUrl,
        "prev_url": prevUrl,
    };
}