class BranchModel {
  int status;
  bool error;
  String message;
  PageDetail pageDetail;
  List<BranchData> data;

  BranchModel({
    required this.status,
    required this.error,
    required this.message,
    required this.pageDetail,
    required this.data,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    pageDetail: PageDetail.fromJson(json["pageDetail"]),
    data: List<BranchData>.from(json["data"].map((x) => BranchData.fromJson(x))),
  );
}

class BranchData {
  String uid;
  String branch;

  BranchData({
    required this.uid,
    required this.branch,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) => BranchData(
    uid: json["uid"],
    branch: json["branch"],
  );
}

class PageDetail {
  int total;
  int perPage;
  int nextPage;
  int prevPage;
  int currentPage;
  String nextUrl;
  String prevUrl;

  PageDetail({
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.prevPage,
    required this.currentPage,
    required this.nextUrl,
    required this.prevUrl,
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
