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
}

class GetUserMentionData {
  String id;
  String avatar;
  String username;
  String name;
  String createdAt;

  GetUserMentionData({
    required this.id,
    required this.avatar,
    required this.username,
    required this.name,
    required this.createdAt,
  });

  factory GetUserMentionData.fromJson(Map<String, dynamic> json) => GetUserMentionData(
    id: json["id"],
    avatar: json["avatar"],
    username: json["username"],
    name: json["name"],
    createdAt: json["created_at"]!,
  );
}
