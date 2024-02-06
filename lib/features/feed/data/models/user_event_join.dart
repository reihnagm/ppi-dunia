class JoinedEventModel {
    int status;
    bool error;
    String message;
    List<JoinedEventData> data;

    JoinedEventModel({
        required this.status,
        required this.error,
        required this.message,
        required this.data,
    });

    factory JoinedEventModel.fromJson(Map<String, dynamic> json) => JoinedEventModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<JoinedEventData>.from(json["data"].map((x) => JoinedEventData.fromJson(x))),
    );
}

class JoinedEventData {
    String? id;
    String? picture;
    String? title;
    String? description;
    String? date;
    bool? paid;
    String? location;
    String? start;
    String? end;
    String? createdAt;

    JoinedEventData({
        this.id,
        this.picture,
        this.title,
        this.description,
        this.date,
        this.paid,
        this.location,
        this.start,
        this.end,
        this.createdAt,
    });

    factory JoinedEventData.fromJson(Map<String, dynamic> json) => JoinedEventData(
        id: json["id"],
        picture: json["picture"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        paid: json["paid"],
        location: json["location"],
        start: json["start"],
        end: json["end"],
        createdAt: json["created_at"],
    );
}