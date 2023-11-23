import 'package:flutter/material.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/second_step_screen/new_password_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';

class NewPasswordFormWidget extends StatelessWidget {
  const NewPasswordFormWidget({
    super.key,
    required this.viewModel,
  });

  final NewPasswordScreenModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: CustomTextField(
            controller: viewModel.verificationCodeC,
            labelText: getTranslated('VERIFICATION_CODE'),
            hintText: getTranslated('VERIFICATION_CODE_HINT'),
            emptyText: getTranslated('VERIFICATION_CODE_EMPTY'),
            textInputType: TextInputType.text,
            isAlphabetsAndNumbers: true,
            focusNode: viewModel.verificationCodeFn,
            nextNode: viewModel.newPasswordFn,
            textInputAction: TextInputAction.next,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: CustomTextField(
            controller: viewModel.newPasswordC,
            labelText: getTranslated('NEW_PASSWORD'),
            hintText: getTranslated('NEW_PASSWORD_HINT'),
            emptyText: getTranslated('NEW_PASSWORD_EMPTY'),
            isPassword: true,
            textInputType: TextInputType.text,
            focusNode: viewModel.newPasswordFn,
            nextNode: viewModel.confirmPasswordFn,
            textInputAction: TextInputAction.next,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: CustomTextField(
            controller: viewModel.confirmPasswordC,
            labelText: getTranslated('CONFIRM_PASSWORD'),
            hintText: getTranslated('CONFIRM_PASSWORD_HINT'),
            emptyText: getTranslated('CONFIRM_PASSWORD_EMPTY'),
            isPassword: true,
            textInputType: TextInputType.text,
            focusNode: viewModel.confirmPasswordFn,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }
}
