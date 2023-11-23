import 'package:ppidunia/localization/app_localization.dart';
import 'package:ppidunia/common/utils/global.dart';

String getTranslated(String key) {
  return AppLocalization.of(navigatorKey.currentContext!).translate(key);
}