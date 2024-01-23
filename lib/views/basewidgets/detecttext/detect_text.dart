import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/webview/webview.dart';

class DetectText extends StatelessWidget {
  final String text;
  const DetectText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return DetectableText(
        text: text,
        trimLines: 3,
        trimLength: 100,
        trimExpandedText: ' Show Less',
        trimCollapsedText: 'Read More',
        detectionRegExp: RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+'),
        detectedStyle: const TextStyle(
          color: ColorResources.blue,
          fontSize: Dimensions.fontSizeSmall,
          fontFamily: 'SF Pro'
        ),
        basicStyle: const TextStyle(
          color: ColorResources.hintColor,
          fontSize: Dimensions.fontSizeSmall,
          fontFamily: 'SF Pro'
        ),
        moreStyle: const TextStyle(
          color: ColorResources.blue,
          fontSize: Dimensions.fontSizeDefault,
          fontFamily: 'SF Pro'
        ),
        lessStyle: const TextStyle(
          color: ColorResources.blue,
          fontSize: Dimensions.fontSizeDefault,
          fontFamily: 'SF Pro'
        ),
        onTap: (tappedText){
          NS.push(context, WebViewScreen(url: tappedText, title: "PPI-DUNIA"));
        },
    );
  }
}