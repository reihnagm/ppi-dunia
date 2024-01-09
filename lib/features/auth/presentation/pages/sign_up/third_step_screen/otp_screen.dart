import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/views/basewidgets/background/grey.dart';
import 'package:ppidunia/views/basewidgets/willpopscope/willpopscope.dart'
    as pop;
import 'package:ppidunia/features/auth/presentation/pages/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/third_step_screen/otp_state.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/auth_column_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/otp_buttons_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/otp_content_widget.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/widgets/otp_title_widget.dart';
import 'package:provider/provider.dart';

class OtpScreenState extends State<OtpScreen> {
  late OtpScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<OtpScreenModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.resetOnProcessOTP(context);
      viewModel.initEmail();
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
                child: Wrap(
                  children: [
                    AuthColumnWidget(
                        screenSize: screenSize,
                        top: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Image.asset(
                                  AssetsConst.imageLogoOtp,
                                  height: screenSize.height * 0.25,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: OtpTitleTextWidget(),
                              ),
                            ],
                          ),
                        ),
                        content: const OtpContentWidget(),
                        contentHeight: 0.15,
                        bottom: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: OtpButtonsWidget(),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
