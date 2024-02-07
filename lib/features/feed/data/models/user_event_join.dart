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
    String? location;
    String? start;
    String? end;
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
        startDate: json["start_date"],
        endDate: json["end_date"],
        joined: json["joined"],
    );
}