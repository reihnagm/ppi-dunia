import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/first_step_screen/sign_up_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/first_step_screen/sign_up_state.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/auth_column_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/sign_up_buttons_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/sign_up_form_widget.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';

class SignUpScreenState extends State<SignUpScreen> {
  late SignUpScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<SignUpScreenModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.resetAgreement();
      viewModel.resetControllerValue();
    });
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
              child: Wrap(
                children: [
                  AuthColumnWidget(
                    screenSize: screenSize,
                    top: Text(
                      getTranslated('SIGN_UP_HERE'),
                      style: sfProRegular.copyWith(
                        fontSize: Dimensions.fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    contentHeight: 0.6,
                    content: SignUpFormWidget(viewModel: viewModel),
                    bottom: const Hero(
                        tag: 'smooth-btn',
                        child: Material(
                          type: MaterialType.transparency,
                          child: SignUpButtonsWidget(),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
