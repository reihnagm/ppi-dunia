class EventModel {
    int status;
    bool error;
    String message;
    List<EventData> data;

    EventModel({
        required this.status,
        required this.error,
        required this.message,
        required this.data,
    });

    factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
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