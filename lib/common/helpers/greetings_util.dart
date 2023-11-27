import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';

class GreetingsHelper {
  static greetings(BuildContext context) {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return getTranslated("GOOD_MORNING");
    }
    if (hour < 17) {
      return getTranslated("GOOD_AFTERNOON");
    }
    return getTranslated("GOOD_EVENING");
  }
}
