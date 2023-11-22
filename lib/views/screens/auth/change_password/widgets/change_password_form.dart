import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';
import 'package:ppidunia/views/screens/auth/change_password/change_password_screen_model.dart';

class ChangePasswordFormWidget extends StatelessWidget {
  const ChangePasswordFormWidget({
    super.key,
    required this.viewModel,
  });

  final ChangePasswordScreenModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: CustomTextField(
            controller: viewModel.oldPasswordC,
            labelText: getTranslated('OLD_PASSWORD'),
            hintText: getTranslated('OLD_PASSWORD_HINT'),
            emptyText: getTranslated('OLD_PASSWORD_EMPTY'),
            textInputType: TextInputType.text,
            isPassword: true,
            focusNode: viewModel.oldPasswordFn,
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