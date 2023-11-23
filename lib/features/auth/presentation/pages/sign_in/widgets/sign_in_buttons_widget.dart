import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/first_step_screen/sign_up_state.dart';

class SignInButtonsWidget extends StatelessWidget {
  const SignInButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            Consumer<SignInScreenModel>(builder: (context, model, _) {
              return CustomButton(
                isLoading:
                    model.loginStatus == LoginStatus.loading ? true : false,
                onTap: () => model.submitControllerValue(context),
                isBorderRadius: true,
                btnTxt: getTranslated('LOGIN'),
              );
            }),
            // Platform.isIOS
            // ? Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 15.0),
            //       child: Text(getTranslated('LOGIN_WITH', context),
            //         style: sfProRegular,
            //       ),
            //     ),
            //     CustomButton(
            //       onTap: () => NS.pushDefault(context, const ComingSoonScreen()),
            //       isBorderRadius: true,
            //       btnTxt: getTranslated('FACE_ID_VERIFICATION', context),
            //       btnTextColor: ColorResources.primaryButton,
            //       btnColor: ColorResources.white,
            //       isPrefixIcon: true,
            //       prefixIcon: Image.asset('assets/images/auth/face-id.png',
            //         fit: BoxFit.cover,
            //         height: Dimensions.iconSizeDefault,
            //         width: Dimensions.iconSizeDefault,
            //       ),
            //     ),
            //   ],
            // )
            // : const SizedBox.shrink(),
            GestureDetector(
              onTap: () => NS.pushDefault(context, const SignUpScreen()),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: getTranslated('NO_ACCOUNT'),
                      ),
                      TextSpan(
                        text: '  ${getTranslated('NO_ACCOUNT_TOGGLE')}',
                        style: sfProRegular.copyWith(
                          color: ColorResources.primaryButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
