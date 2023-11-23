import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/widgets/sign_in_buttons_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/widgets/sign_in_form_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/auth_column_widget.dart';
import 'package:provider/provider.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_state.dart';
import 'package:ppidunia/views/basewidgets/willpopscope/willpopscope.dart'
    as pop;
import 'package:flutter/scheduler.dart' show timeDilation;

class SignInScreenState extends State<SignInScreen> {
  late SignInScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    timeDilation = 2.0;
    viewModel = context.read<SignInScreenModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.resetSignIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
        onWillPop: () => pop.willPopScope(context),
        child: Scaffold(
            body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: GreyBackgroundWidget(
            screenSize: screenSize,
            child: SingleChildScrollView(
              child: AuthColumnWidget(
                screenSize: screenSize,
                top: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AssetsConst.imageLogoSignIn,
                      height: screenSize.height * 0.25,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        getTranslated('SIGN_IN_HERE'),
                        style: sfProRegular.copyWith(
                          fontSize: Dimensions.fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                content: SignInFormWidget(viewModel: viewModel),
                contentHeight: 0.3,
                bottom: const Hero(
                    tag: 'smooth-btn',
                    child: Material(
                      type: MaterialType.transparency,
                      child: SignInButtonsWidget(),
                    )),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
