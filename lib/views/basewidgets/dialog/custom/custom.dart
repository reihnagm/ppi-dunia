import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';

class CustomDialog {

  AwesomeDialog showWaitingApproval(BuildContext context) {
    return AwesomeDialog(
      autoHide: const Duration(seconds: 5),
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      btnOkText: "Ok",
      btnOkColor: ColorResources.secondary,
      btnOkOnPress: () { 

      },
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Menunggu Approval',
              style: sfProRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 15,),
            Text('Mohon tunggu beberapa saat agar Anda bisa menggunakan fitur pada KOPERASI Mobile Apps.',
              style: sfProRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
    )..show();
  }

  static AwesomeDialog showError(BuildContext context, {required String error}) {
    return AwesomeDialog(
      autoHide: const Duration(seconds: 5),
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      btnOkText: "Ok",
      btnOkColor: ColorResources.secondary,
      btnOkOnPress: () { 
        NS.pop(context);
      },
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Oops! Please try again',
              style: sfProRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeExtraLarge,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 15,),
            Text(error,
              style: sfProRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeLarge,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
    )..show();
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 15),child: const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}