import 'package:flutter_test/flutter_test.dart';
import 'package:ppidunia/features/country/data/models/country.dart';

import '../../dummy_data/country/mock_country.dart';

void main() {
  group("Test CountryData initialization from json", () {
    late Map<String, dynamic> apiCountryAsJson;
    late CountryData expectedApiCountry;

    setUp(() {
      apiCountryAsJson = MockCountry.dummyCountryJson;
      expectedApiCountry = MockCountry.expectedCountryData;
    });

    test('should be a Country data', () {
      //act
      var result = CountryData.fromJson(apiCountryAsJson);
      //assert
      expect(result, isA<CountryData>());
    });

    test('should not be a Country model', () {
      //act
      var result = CountryData.fromJson(apiCountryAsJson);
      //assert
      expect(result, isNot(CountryModel()));
    });

    test('result should be as expected', () {
      //act
      var result = CountryData.fromJson(apiCountryAsJson);
      //assert
      expect(result, expectedApiCountry);
    });
  });
}
