import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:ppidunia/views/screens/auth/forget_password/second_step_screen/new_password_screen_model.dart';
import 'package:ppidunia/views/screens/auth/forget_password/second_step_screen/new_password_state.dart';
import 'package:ppidunia/views/screens/auth/forget_password/widgets/new_password_button.dart';
import 'package:ppidunia/views/screens/auth/forget_password/widgets/new_password_form.dart';
import 'package:ppidunia/views/screens/auth/sign_up/widgets/auth_column_widget.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/utils/custom_themes.dart';


class NewPasswordScreenState extends State<NewPasswordScreen> {
  late NewPasswordScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<NewPasswordScreenModel>();
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
                  top: Text(getTranslated('FORGET_PASSWORD_HERE'),
                    style: sfProRegular.copyWith(
                      fontSize: Dimensions.fontSizeTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: NewPasswordFormWidget(viewModel: viewModel),
                  bottom: const Hero(
                    tag: 'smooth-btn',
                    child: Material(
                      type: MaterialType.transparency,
                      child: NewPasswordButtonWidget(),
                    )
                  ),
                  ),
              ),
            ),
          )
      ),
    );
  }

}