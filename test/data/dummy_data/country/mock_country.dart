import 'package:ppidunia/data/models/country/country.dart';

class MockCountry {
  static const CountryData expectedCountryData = CountryData(
    uid: "a8319eef-6da6-4938-9446-cfa7999b51d6",
    name: "Country Test",
    branch: "Testing",
  );

  static final Map<String, dynamic> dummyCountryJson = expectedCountryData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "pageDetail": {
      "total": 1,
      "per_page": 1,
      "next_page": 2,
      "prev_page": 1,
      "current_page": 1,
      "next_url": "any",
      "prev_url": "any",
    },
    "data": [
      dummyCountryJson,
    ]
  };
}
