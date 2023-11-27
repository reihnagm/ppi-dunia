import 'package:flutter/material.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/consts/assets_const.dart';

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
        Image.asset(AssetsConst.imageLogoOmega,
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
        Image.asset(AssetsConst.imageLogoInovatif,
          width: screenSize.width * 0.15,
        ),
      ],
    );
  }
}