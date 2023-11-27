import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/first_step_screen/forget_password_state.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_screen_model.dart';

class SignInFormWidget extends StatelessWidget {
  const SignInFormWidget({
    super.key,
    required this.viewModel,
  });

  final SignInScreenModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Hero(
            tag: 'email-pw',
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                children: [
                  CustomTextField(
                    labelText: 'Email',
                    isEmail: true,
                    controller: viewModel.emailC,
                    hintText: getTranslated('EMAIL_HINT'),
                    emptyText: getTranslated('EMAIL_EMPTY'),
                    textInputType: TextInputType.emailAddress,
                    focusNode: viewModel.emailFn,
                    nextNode: viewModel.passwordFn,
                    textInputAction: TextInputAction.next,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: CustomTextField(
                      labelText: getTranslated('PASSWORD'),
                      isPassword: true,
                      controller: viewModel.passwordC,
                      hintText: getTranslated('PASSWORD_HINT'),
                      emptyText: getTranslated('PASSWORD_EMPTY'),
                      textInputType: TextInputType.emailAddress,
                      focusNode: viewModel.passwordFn,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => NS.pushDefault(context, const ForgetPasswordScreen()),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: getTranslated('FORGET_PASSWORD'),
                        ),
                        TextSpan(
                          text: '  ${getTranslated('FORGET_PASSWORD_TOGGLE')}',
                          style: sfProRegular.copyWith(
                            color: ColorResources.primaryButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
