import 'package:flutter/material.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/first_step_screen/forget_password_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/basewidgets/textfield/textfield.dart';

class ForgetPasswordContentWidget extends StatelessWidget {
  const ForgetPasswordContentWidget({
    super.key,
    required this.viewModel,
  });

  final ForgetPasswordScreenModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: viewModel.emailC,
      labelText: 'Email',
      hintText: getTranslated('EMAIL_HINT'),
      emptyText: getTranslated('EMAIL_EMPTY'),
      isEmail: true,
      textInputType: TextInputType.emailAddress,
      focusNode: viewModel.emailFn,
      textInputAction: TextInputAction.done,
    );
  }
}
