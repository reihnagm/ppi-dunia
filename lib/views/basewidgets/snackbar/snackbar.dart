import 'package:flutter/material.dart';

import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';

class ShowSnackbar {
  ShowSnackbar._();
  static snackbar(BuildContext context, String content, String label, Color backgroundColor, [Duration? time]) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: time ?? const Duration(seconds: 2),
        backgroundColor: backgroundColor,
        content: Text(
          content, 
          style: sfProRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeLarge
        )),
        action: SnackBarAction(
          textColor: ColorResources.white,
          label: label,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()
        ),
      )
    );
  }
}