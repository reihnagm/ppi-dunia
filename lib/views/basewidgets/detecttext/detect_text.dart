import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/extensions/snackbar.dart';
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
        detectionRegExp: RegExp(r'(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)|([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)|@[a-zA-Z0-9_.]+?(?![a-zA-Z0-9_.]|[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$)'),
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
            launchEmailSubmission(tappedText, context);
          } else if(mention){
            NS.push(context, ProfileViewScreen(userId: userid ?? ""));
          }  
          else{
            NS.push(context, NS.push(context, WebViewScreen(url: tappedText.toLowerCase(), title: "PPI-DUNIA")));
          }
        },
    );
  }
  void launchEmailSubmission(String email, BuildContext context) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      // queryParameters: {
      //   'subject': 'Default Subject',
      //   'body': 'Default body'
      // }
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      await Clipboard.setData(ClipboardData(text: email));
      // ignore: use_build_context_synchronously
      ShowSnackbar.snackbar(context, "Content copied to clipboard", '', ColorResources.success, const Duration(seconds: 6),);
      print('Could not launch $params');
    }
  }
}