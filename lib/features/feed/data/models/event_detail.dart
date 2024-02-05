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
    bool? paid;
    String? location;
    String? start;
    String? end;
    String? startDate;
    String? endDate;
    bool? joined;

    EventDetailData({
        this.id,
        this.picture,
        this.title,
        this.description,
        this.paid,
        this.location,
        this.start,
        this.end,
        this.startDate,
        this.endDate,
        this.joined,
    });

    factory EventDetailData.fromJson(Map<String, dynamic> json) => EventDetailData(
        id: json["id"],
        picture: json["picture"],
        title: json["title"],
        description: json["description"],
        paid: json["paid"],
        location: json["location"],
        start: json["start"],
        end: json["end"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        joined: json["joined"],
    );
}