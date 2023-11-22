class SingleNewsModel {
    SingleNewsModel({
        this.status,
        this.error,
        this.message,
        this.data,
    });

    int? status;
    bool? error;
    String? message;
    SingleNewsData? data;

    factory SingleNewsModel.fromJson(Map<String, dynamic> json) => SingleNewsModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: SingleNewsData.fromJson(json["data"]),
    );
}

class SingleNewsData {
    SingleNewsData({
        this.uid,
        this.title,
        this.description,
        this.image,
    });

    String? uid;
    String? title;
    String? description;
    String? image;

    factory SingleNewsData.fromJson(Map<String, dynamic> json) => SingleNewsData(
        uid: json["uid"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
    );
}
