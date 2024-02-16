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
    bool? isExpired;
    String? startDate;
    String? endDate;
    bool? joined;
    List<JoinedUserData>? users;

    EventDetailData({
        this.id,
        this.picture,
        this.title,
        this.description,
        this.paid,
        this.location,
        this.start,
        this.end,
        this.isExpired,
        this.startDate,
        this.endDate,
        this.joined,
        this.users,
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
        isExpired: json["is_expired"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        joined: json["joined"],
        users: List<JoinedUserData>.from(json["users"].map((x) => JoinedUserData.fromJson(x))),
    );
}

class JoinedUserData {
    String id;
    String firstName;
    String lastName;
    String email;
    String phone;
    String gender;
    String status;
    String agency;
    String createdAt;
    String updatedAt;

    JoinedUserData({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.phone,
        required this.gender,
        required this.status,
        required this.agency,
        required this.createdAt,
        required this.updatedAt,
    });

    factory JoinedUserData.fromJson(Map<String, dynamic> json) => JoinedUserData(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        status: json["status"],
        agency: json["agency"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );
}