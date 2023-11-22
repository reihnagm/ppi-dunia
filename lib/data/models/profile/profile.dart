class ProfileModel {
  int status;
  bool error;
  String message;
  ProfileData data;

  ProfileModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: ProfileData.fromJson(json["data"]),
  );
}

class ProfileData {
  String? id;
  String? avatar;
  String? fullname;
  String? email;
  String? phone;
  String? role;
  Country? country;

  ProfileData({
    this.id,
    this.avatar,
    this.fullname,
    this.email,
    this.phone,
    this.role,
    this.country,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    avatar: json["avatar"],
    fullname: json["fullname"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
    country: Country.fromJson(json["country"]),
  );
}

class Country {
  String name;
  String branch;

  Country({
    required this.name,
    required this.branch,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["name"],
    branch: json["branch"],
  );
}
