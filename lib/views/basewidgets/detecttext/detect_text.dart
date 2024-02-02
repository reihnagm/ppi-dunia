import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/pages/profile_view/profile_view_state.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/views/webview/webview.dart';
import 'package:url_launcher/url_launcher.dart';

class DetectText extends StatelessWidget {
  final String text;
  final String? userid;
  const DetectText({super.key, required this.text, this.userid});

  @override
  Widget build(BuildContext context) {
    return DetectableText(
        text: text,
        trimLines: 3,
        trimLength: 300,
        trimExpandedText: ' Show Less',
        trimCollapsedText: 'Read More',
        detectionRegExp: RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$|(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+|@[a-zA-Z0-9_.]+?(?![a-zA-Z0-9_.]|[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$)'),
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
          final email =  tappedText.contains(RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'));
          final mention =  tappedText.contains(RegExp(r'^@[a-zA-Z0-9_.]+?(?![a-zA-Z0-9_.])'));
          debugPrint(tappedText);

          if (email) {
            launchEmailSubmission(tappedText);
          } else if(mention){
            NS.push(context, ProfileViewScreen(userId: userid ?? ""));
          }  
          else{
            NS.push(context, NS.push(context, WebViewScreen(url: tappedText.toLowerCase(), title: "PPI-DUNIA")));
          }
        },
    );
  }
  void launchEmailSubmission(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      // queryParameters: {
      //   'subject': 'Default Subject',
      //   'body': 'Default body'
      // }
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}