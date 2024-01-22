class GetUserMention {
    int status;
    bool error;
    String message;
    List<GetUserMentionData> data;

    GetUserMention({
        required this.status,
        required this.error,
        required this.message,
        required this.data,
    });

    factory GetUserMention.fromJson(Map<String, dynamic> json) => GetUserMention(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<GetUserMentionData>.from(json["data"].map((x) => GetUserMentionData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class GetUserMentionData {
    String id;
    String avatar;
    String name;
    String createdAt;

    GetUserMentionData({
        required this.id,
        required this.avatar,
        required this.name,
        required this.createdAt,
    });

    factory GetUserMentionData.fromJson(Map<String, dynamic> json) => GetUserMentionData(
        id: json["id"],
        avatar: json["avatar"],
        name: json["name"],
        createdAt: json["created_at"]!,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "name": name,
        "created_at": createdAt,
    };
}
