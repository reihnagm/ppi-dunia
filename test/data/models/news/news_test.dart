import 'package:flutter_test/flutter_test.dart';
import 'package:ppidunia/data/models/news/news.dart';
import '../../dummy_data/news/mock_news.dart';

void main() {
  group("Test NewsData initialization from json", () {
    late Map<String, dynamic> apiNewsAsJson;
    late NewsData expectedApiNews;

    setUp(() {
      apiNewsAsJson = MockNews.dummyNewsJson;
      expectedApiNews = MockNews.expectedNewsData;
    });

    test('should be a News data', () {
      //act
      var result = NewsData.fromJson(apiNewsAsJson);
      //assert
      expect(result, isA<NewsData>());
    });

    test('should not be a News model', () {
      //act
      var result = NewsData.fromJson(apiNewsAsJson);
      //assert
      expect(result, isNot(NewsModel()));
    });

    test('result should be as expected', () {
      //act
      var result = NewsData.fromJson(apiNewsAsJson);
      //assert
      expect(result, expectedApiNews);
    });
  });
}
