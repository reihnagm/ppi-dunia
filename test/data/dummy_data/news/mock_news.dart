import 'package:ppidunia/data/models/news/news.dart';
import 'package:ppidunia/utils/helper.dart';

class MockNews {
  static final NewsData expectedNewsData = NewsData(
    uid: "a8319eef-6da6-4938-9446-cfa7999b51d6",
    title: "News Test",
    description: "This is just a test.",
    image: "https://media.istockphoto.com/id/1309699912/vector/vector-illustration-daily-news-paper-template-with-text-and-picture-placeholder.jpg?s=612x612&w=0&k=20&c=xyCcw4mibGweJ1exlqmhFqWNumkbPTzx-YiqXZj-kxc=",
    createdAt: Helper.formatDate(DateTime.now()),
  );

  static final Map<String, dynamic> dummyNewsJson = expectedNewsData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "data": [
      dummyNewsJson,
    ]
  };
}
