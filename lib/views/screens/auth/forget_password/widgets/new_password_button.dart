import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/views/screens/auth/forget_password/second_step_screen/new_password_screen_model.dart';

class NewPasswordButtonWidget extends StatelessWidget {
  const NewPasswordButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NewPasswordScreenModel>(
      builder: (context, model, _) {
        return CustomButton(
          isBorderRadius: true,
          isLoading: model.setNewPasswordStatus == SetNewPasswordStatus.loading ? true : false,
          btnTxt: getTranslated('SUBMIT'),
          onTap: () => model.submitControllerValue(context),
        );
      }
    );
  }
}
