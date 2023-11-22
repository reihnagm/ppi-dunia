import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/screens/auth/forget_password/first_step_screen/forget_password_screen_model.dart';

class ForgetPasswordButtonWidget extends StatelessWidget {
  const ForgetPasswordButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgetPasswordScreenModel>(
      builder: (context, model, _) {
        return CustomButton(
          isBorderRadius: true,
          isLoading: model.forgetPasswordStatus == ForgetPasswordStatus.loading ? true : false,
          btnTxt: getTranslated('CONTINUE'),
          onTap: () => model.submitControllerValue(context),
        );
      }
    );
  }
}
