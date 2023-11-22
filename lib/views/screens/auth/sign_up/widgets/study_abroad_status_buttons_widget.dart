import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';

import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/screens/auth/sign_in/sign_in_state.dart';
import 'package:ppidunia/views/screens/auth/sign_up/second_step_screen/study_abroad_status_screen_model.dart';

class StudyAbroadStatusButtonsWidget extends StatelessWidget {
  const StudyAbroadStatusButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Consumer<StudyAbroadStatusScreenModel>(
          builder: (context, viewModel, _) {
            return CustomButton(
              isLoading: viewModel.assignCountryStatus == AssignCountryStatus.loading ? true : false,
              onTap: () => viewModel.submit(context),
              isBorderRadius: true,
              btnTxt: getTranslated('SUBMIT'),
            );
          }
        ),
        GestureDetector(
          onTap: () => NS.pushReplacementDefault(context, const SignInScreen()),
          child: Center(
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
          ),
        )
      ],
    );
  }
}

