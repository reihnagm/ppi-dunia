class EventDetailModel {
    int status;
    bool error;
    String message;
    EventDetailData data;

    EventDetailModel({
        required this.status,
        required this.error,
        required this.message,
        required this.data,
    });

    factory EventDetailModel.fromJson(Map<String, dynamic> json) => EventDetailModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: EventDetailData.fromJson(json["data"]),
    );
}

class EventDetailData {
    String? id;
    String? picture;
    String? title;
    String? description;
    String? date;
    String? location;
    String? start;
    String? end;
    bool? joined;

    EventDetailData({
        this.id,
        this.picture,
        this.title,
        this.description,
        this.date,
        this.location,
        this.start,
        this.end,
        this.joined,
    });

    factory EventDetailData.fromJson(Map<String, dynamic> json) => EventDetailData(
        id: json["id"],
        picture: json["picture"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        location: json["location"],
        start: json["start"],
        end: json["end"],
        joined: json["joined"],
    );
}