import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/button/bounce.dart';
import 'package:ppidunia/views/basewidgets/credits/credits_widget.dart';
import 'package:ppidunia/views/screens/auth/sign_in/sign_in_state.dart';
import 'package:ppidunia/views/screens/splash/splash_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ppidunia/utils/color_resources.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  int currentIndex = 0;
  
  late CarouselController cc;

  List<Map<String, dynamic>> assets = [
    {
      "image": "assets/images/onboarding/onboarding-1.png",
      "text": "ONBOARDING_1",
    },
    {
      "image": "assets/images/onboarding/onboarding-2.png",
      "text": "ONBOARDING_2",
    },
    {
      "image": "assets/images/onboarding/onboarding-3.png",
      "text": "ONBOARDING_3",
    },
  ];

  @override
  void initState() {
    cc = CarouselController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.screenSize.height * 0.6,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CreditsWidget(screenSize: widget.screenSize),
          ),
          buildOnboardingContent(),
          Expanded(
            child: buildSkipButton(context),
          )
        ],
      ),
    );
  }

  Container buildOnboardingContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60.0),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      height: widget.screenSize.height * 0.4,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/background/bg-purple-plain.png'),
          fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: ColorResources.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CarouselSlider.builder(
            carouselController: cc,
            itemCount: assets.length,
            itemBuilder: (context, index, realIndex) {
              return buildOnboardingItem(index, context);
            },
            options: CarouselOptions(
              height: widget.screenSize.height * 0.3,
              initialPage: currentIndex,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                currentIndex = index;
                setState(() { });
              },
              
            ),
          ),
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              curve: Curves.ease,
              count: assets.length,
              duration: const Duration(milliseconds: 75),
              onEnd: () {
                if(currentIndex == assets.length - 1) {
                  context.read<SplashScreenModel>().dispatchOnboarding(true);
                  Future.delayed(const Duration(seconds: 1), () {
                    NS.pushReplacementDefault(context, const SignInScreen());
                  },);
                }
              },
              effect: const ScrollingDotsEffect(
                activeDotColor: ColorResources.white,
                dotHeight: 8.0,
                dotWidth: 8.0,
              ),
            )
          )
        ],
      ),
    );
  }

  DelayedDisplay buildSkipButton(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(seconds:  1),
      fadingDuration: const Duration(milliseconds: 350),
      slidingCurve: Curves.easeOutExpo,
      slidingBeginOffset: const Offset(0, 5),
      child: Bouncing(
        onPress: () {
          context.read<SplashScreenModel>().dispatchOnboarding(true);
          NS.pushReplacementDefault(context, const SignInScreen());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getTranslated('SKIP?'),
              style: sfProRegular.copyWith(
                fontSize: 22.0
              ),
            ),
            const SizedBox(width: 10,),
            Text(getTranslated('YES'),
              style: sfProRegular.copyWith(
                fontSize: 22.0,
                color: ColorResources.primaryButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildOnboardingItem(int index, BuildContext context) {
    return SizedBox(
      width: widget.screenSize.width * 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(assets[index]["image"],
              height: widget.screenSize.height * 0.16,
              fit: BoxFit.fitHeight,
            ),
            Text(getTranslated(assets[index]["text"]),
              textAlign: TextAlign.center,
              softWrap: true,
              style: sfProRegular.copyWith(
                fontSize: widget.screenSize.height > 360.0
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
