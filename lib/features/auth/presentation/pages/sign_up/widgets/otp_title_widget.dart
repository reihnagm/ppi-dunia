import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

import 'package:ppidunia/features/auth/presentation/pages/sign_up/third_step_screen/otp_screen_model.dart';

class OtpTitleTextWidget extends StatelessWidget {
  const OtpTitleTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpScreenModel>(builder: (context, model, _) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: model.onProcessOTP
            ? Column(
                key: const Key('title-ongoing'),
                children: [
                  Text(
                    getTranslated('VERIFY_EMAIL'),
                    style: sfProRegular.copyWith(
                      fontSize: Dimensions.fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${getTranslated('ENTER_OTP')} ${model.oldEmail}",
                    style: sfProRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Column(
                key: const Key('title-success'),
                children: [
                  Text(
                    "${getTranslated('VERIFIED')}!",
                    style: sfProRegular.copyWith(
                      fontSize: Dimensions.fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                ],
              ),
      );
    });
  }
}
