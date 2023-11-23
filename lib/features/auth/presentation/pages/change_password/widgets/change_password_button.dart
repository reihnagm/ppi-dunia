import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/features/auth/presentation/pages/change_password/change_password_screen_model.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordScreenModel>(builder: (context, model, _) {
      return CustomButton(
        isBorderRadius: true,
        isLoading: model.changePasswordStatus == ChangePasswordStatus.loading
            ? true
            : false,
        btnTxt: getTranslated('SUBMIT'),
        onTap: () => model.submitControllerValue(context),
      );
    });
  }
}
