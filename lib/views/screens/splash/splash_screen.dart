import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ppidunia/views/screens/splash/splash_screen_model.dart';
import 'package:ppidunia/views/screens/splash/splash_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/willpopscope/willpopscope.dart' as pop;
import 'package:flutter/scheduler.dart' show timeDilation;

class SplashScreenState extends State<SplashScreen> {
  late SplashScreenModel viewModel; 

  @override 
  void initState() {
    super.initState();

    viewModel = context.read<SplashScreenModel>();

    timeDilation = 5.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initPackageInfo();
      viewModel.getData(context);
      Timer(const Duration(seconds: 3), () {
        viewModel.navigateScreen(context);
      });
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/logo/logo.png'), context);
    precacheImage(const AssetImage('assets/images/background/bg.png'), context);
    precacheImage(const AssetImage('assets/images/avatar/avatar-welcome.png'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return WillPopScope(
      onWillPop: () => pop.willPopScope(context),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/background/bg.png'),
                  )
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child:  Hero(
                        tag: 'logo-welcome',
                        child: Container(
                          width: 400.0,
                          height: 400.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/logo/logo.png'))
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 30.0,
                      child: Consumer<SplashScreenModel>(
                        builder: (context, model, _) {
                          return Center(
                            child: Text("${getTranslated("VERSION")} ${model.packageInfo.version}",
                              style: sfProRegular.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.fontSizeLarge,
                                color: ColorResources.white
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      )
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}