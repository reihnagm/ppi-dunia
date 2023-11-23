import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/features/auth/presentation/pages/change_password/change_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/change_password/change_password_state.dart';
import 'package:ppidunia/features/auth/presentation/pages/change_password/widgets/change_password_button.dart';
import 'package:ppidunia/features/auth/presentation/pages/change_password/widgets/change_password_form.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/auth_column_widget.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';

import 'package:ppidunia/views/basewidgets/background/grey.dart';

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ChangePasswordScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<ChangePasswordScreenModel>();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GreyBackgroundWidget(
          screenSize: screenSize,
          child: SingleChildScrollView(
            child: AuthColumnWidget(
              screenSize: screenSize,
              top: Text(
                getTranslated('CHANGE_PASSWORD_HERE'),
                style: sfProRegular.copyWith(
                  fontSize: Dimensions.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: ChangePasswordFormWidget(viewModel: viewModel),
              bottom: const Hero(
                  tag: 'smooth-btn',
                  child: Material(
                    type: MaterialType.transparency,
                    child: ChangePasswordButton(),
                  )),
            ),
          ),
        ),
      )),
    );
  }
}
