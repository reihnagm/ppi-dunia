import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/screens/auth/sign_up/first_step_screen/sign_up_screen_model.dart';

class SignUpButtonsWidget extends StatelessWidget {
  const SignUpButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<SignUpScreenModel>(
          builder: (context, viewModel, _) {
            return CustomButton(
              isLoading: viewModel.registerStatus == RegisterStatus.loading ? true : false,
              onTap: () => viewModel.submitControllerValue(context),
              isBorderRadius: true,
              btnTxt: getTranslated('CONTINUE'),
            );
          }
        ),
        GestureDetector(
          onTap: () => NS.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: RichText(text: TextSpan(
              children: [
                TextSpan(text: getTranslated('HAVE_ACCOUNT')),
                TextSpan(text: '  ${getTranslated('HAVE_ACCOUNT_TOGGLE')}',
                  style: sfProRegular.copyWith(
                    color: ColorResources.primaryButton,
                  )
                ),
              ],
            )),
          ),
        )
      ],
    );
  }
}

