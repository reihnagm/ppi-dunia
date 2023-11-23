import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ppidunia/features/splash/presentation/pages/splash_screen_model.dart';
import 'package:ppidunia/features/splash/presentation/pages/splash_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/views/basewidgets/willpopscope/willpopscope.dart'
    as pop;
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
    precacheImage(const AssetImage(AssetsConst.imageLogoPpi), context);
    precacheImage(const AssetImage(AssetsConst.imageBackground), context);
    precacheImage(const AssetImage(AssetsConst.imageAvatarWelcome), context);
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
                  image: AssetImage(AssetsConst.imageBackground),
                )),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: Hero(
                        tag: 'logo-welcome',
                        child: Container(
                          width: 400.0,
                          height: 400.0,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(AssetsConst.imageLogoPpi))),
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
                            child: Text(
                              "${getTranslated("VERSION")} ${model.packageInfo.version}",
                              style: sfProRegular.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: ColorResources.white),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }))
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
