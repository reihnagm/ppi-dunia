import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:provider/provider.dart';

class OtpButtonsWidget extends StatelessWidget {
  const OtpButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpScreenModel>(builder: (context, model, _) {
      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: model.onProcessOTP
              ? Hero(
                  tag: 'smooth-btn',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Wrap(
                      key: const Key('btn-confirm'),
                      children: [
                        CustomButton(
                          isLoading:
                              model.verifyOtpStatus == VerifyOtpStatus.loading
                                  ? true
                                  : false,
                          onTap: () => model.submit(context),
                          isBorderRadius: true,
                          btnTxt: getTranslated('CONFIRM'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomButton(
                            onTap: () => model.buildBottomSheet(context, model),
                            isBorderRadius: true,
                            btnColor: ColorResources.white,
                            btnTextColor: ColorResources.primaryButton,
                            btnTxt: getTranslated('CHANGE_EMAIL'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Hero(
                  tag: 'smooth-btn',
                  child: Column(
                    children: [
                      SizedBox(height: 80,),
                      Material(
                        type: MaterialType.transparency,
                        child: CustomButton(
                          key: const Key('btn-continue'),
                          onTap: () => model.navigateToHome(context),
                          isBorderRadius: true,
                          btnTxt: getTranslated('CONTINUE'),
                        ),
                      ),
                    ],
                  ),
                ));
    });
  }
}
