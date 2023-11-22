import 'package:flutter/material.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';

class CreditsWidget extends StatelessWidget {
  final Size screenSize;
  
  const CreditsWidget({
    super.key, required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('${getTranslated('SUPPORTED_BY')} :',
          style: sfProRegular.copyWith(
            fontSize: screenSize.height > 360.0
            ? Dimensions.fontSizeDefault
            : Dimensions.fontSizeLarge,
          ),
        ),
        Image.asset('assets/images/logo/logo-omega.png',
          width: screenSize.width * 0.15,
        ),
        const SizedBox(width: 10,),
        Text('${getTranslated('POWERED_BY')} :',
          style: sfProRegular.copyWith(
            fontSize: screenSize.height > 360.0
            ? Dimensions.fontSizeDefault
            : Dimensions.fontSizeLarge,
          ),
        ),
        Image.asset('assets/images/logo/LOGO-INOVATIF78.png',
          width: screenSize.width * 0.15,
        ),
      ],
    );
  }
}