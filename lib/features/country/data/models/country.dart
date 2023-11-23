import 'package:equatable/equatable.dart';
// ignore_for_file: constant_identifier_names

class CountryModel {
    final int? status;
    final bool? error;
    final String? message;
    final PageDetail? pageDetail;
    final List<CountryData>? data;

    CountryModel({
        this.status,
        this.error,
        this.message,
        this.pageDetail,
        this.data,
    });

    factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        pageDetail: json["pageDetail"] == null ? null : PageDetail.fromJson(json["pageDetail"]),
        data: json["data"] == null ? [] : List<CountryData>.from(json["data"]!.map((x) => CountryData.fromJson(x))),
    );
}

class CountryData extends Equatable{
    final String? uid;
    final String? name;
    final String? branch;

    const CountryData({
        this.uid,
        this.name,
        this.branch,
    });

    factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        uid: json["uid"],
        name: json["name"],
        branch: json["branch"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "branch": branch,
    };
    
    @override
    List<Object?> get props => [
      uid,
      name,
      branch,
    ];
}

class PageDetail {
    final int? total;
    final int? perPage;
    final int? nextPage;
    final int? prevPage;
    final int? currentPage;
    final String? nextUrl;
    final String? prevUrl;

    PageDetail({
        this.total,
        this.perPage,
        this.nextPage,
        this.prevPage,
        this.currentPage,
        this.nextUrl,
        this.prevUrl,
    });

    factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
    );
}