import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:ppidunia/views/basewidgets/willpopscope/willpopscope.dart' as pop;

import 'package:ppidunia/views/screens/onboarding/widgets/onboarding_widget.dart';
import 'package:ppidunia/views/screens/onboarding/onboarding_state.dart';
import 'package:ppidunia/views/screens/onboarding/onboarding_screen_model.dart';
import 'package:ppidunia/views/screens/onboarding/widgets/welcome_widget.dart';

class OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingScreenModel viewModel;

  @override
  void initState() {
    viewModel = context.read<OnboardingScreenModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setChangeContent();
    });

    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light, 
      child: WillPopScope(
      onWillPop: () => pop.willPopScope(context),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/bg.png'),
              fit: BoxFit.fill
            )
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<OnboardingScreenModel>(
                  builder: (context, model, _) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: model.isChangeContent 
                        ? WelcomeWidget(
                            screenSize: screenSize,
                            key: const Key('welcome-1'),
                          )
                        : OnboardingWidget(
                            screenSize: screenSize,
                            key: const Key('welcome-2'),
                          ),
                    );
                  }
                ),
                Image.asset('assets/images/avatar/avatar-welcome.png',
                  height: screenSize.height * 0.23,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}