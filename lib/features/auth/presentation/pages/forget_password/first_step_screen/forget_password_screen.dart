import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/first_step_screen/forget_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/first_step_screen/forget_password_state.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/widgets/forget_password_button.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/widgets/forget_password_content.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/auth_column_widget.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late ForgetPasswordScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<ForgetPasswordScreenModel>();
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
                getTranslated('FORGET_PASSWORD_HERE'),
                style: sfProRegular.copyWith(
                  fontSize: Dimensions.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              content: ForgetPasswordContentWidget(viewModel: viewModel),
              contentHeight: 0.21,
              bottom: const Hero(
                  tag: 'smooth-btn',
                  child: Material(
                    type: MaterialType.transparency,
                    child: ForgetPasswordButtonWidget(),
                  )),
            ),
          ),
        ),
      )),
    );
  }
}
