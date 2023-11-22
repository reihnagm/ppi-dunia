import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/utils/custom_themes.dart';

class WelcomeWidget extends StatelessWidget {
  final Size screenSize;
  
  const WelcomeWidget({
    super.key, required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Hero(
            tag: 'logo-welcome',
            child: Image.asset('assets/images/logo/logo.png',
              height: screenSize.height * 0.3,
              width: screenSize.height * 0.3,
            ),
          ),
          DelayedDisplay(
            delay: const Duration(milliseconds: 700),
            fadingDuration: const Duration(milliseconds: 350),
            slidingCurve: Curves.easeOutExpo,
            slidingBeginOffset: const Offset(0, 5),
            child: Column(
              children: [
                Text(getTranslated('WELCOME_ONBOARD'),
                  style: sfProRegular.copyWith(
                    fontSize: 22.0
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Perhimpunan Pelajar Indonesia',
                    style: sfProRegular.copyWith(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}