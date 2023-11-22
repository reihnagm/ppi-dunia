import 'package:equatable/equatable.dart';

class NewsModel {
    NewsModel({
        this.status,
        this.error,
        this.message,
        this.data,
    });

    int? status;
    bool? error;
    String? message;
    List<NewsData>? data;

    factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<NewsData>.from(json["data"].map((x) => NewsData.fromJson(x))),
    );
}

class NewsData extends Equatable{
    const NewsData({
        this.uid,
        this.title,
        this.description,
        this.image,
        this.createdAt,
    });

    final String? uid;
    final String? title;
    final String? description;
    final String? image;
    final String? createdAt;

    factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
        uid: json["uid"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
      "uid": uid,
      "title": title,
      "description": description,
      "image": image,
      "created_at": createdAt,
    };

    @override
    List<Object?> get props => [
        uid,
        title,
        description,
        createdAt,
    ];
}
