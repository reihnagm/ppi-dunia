import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';

dynamic currentBackPressTime;

Future<bool> willPopScope(BuildContext context)  {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null || now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    ShowSnackbar.snackbar(context, getTranslated("PRESS_TWICE_BACK"), "", ColorResources.black);
    return Future.value(false);
  }
  SystemNavigator.pop();
  return Future.value(true);
}
