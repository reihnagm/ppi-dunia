import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import 'package:ppidunia/utils/box_shadow.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';

import 'package:ppidunia/views/basewidgets/button/bounce.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String? btnTxt;
  final bool customText;
  final Widget? text;
  final Widget? prefixIcon;
  final double width;
  final double height;
  final double sizeBorderRadius;
  final Color loadingColor;
  final Color btnColor;
  final Color btnTextColor;
  final Color btnBorderColor;
  final bool isBorder;
  final bool isBorderRadius;
  final bool isLoading;
  final bool isBoxShadow;
  final bool isPrefixIcon;

  const CustomButton({
    Key? key, 
    required this.onTap, 
    this.btnTxt, 
    this.customText = false,
    this.text,
    this.width = double.infinity,
    this.height = 50.0,
    this.sizeBorderRadius = 10.0,
    this.isLoading = false,
    this.loadingColor = ColorResources.white,
    this.btnColor = ColorResources.primaryButton,
    this.btnTextColor = ColorResources.white,
    this.btnBorderColor = Colors.transparent,
    this.isBorder = false,
    this.isBorderRadius = false,
    this.isBoxShadow = false,
    this.isPrefixIcon = false,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onPress: isLoading ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: isBoxShadow 
          ? boxShadow 
          : [],
          color: btnColor,
          border: Border.all(
            color: isBorder 
            ? btnBorderColor 
            : Colors.transparent,
          ),
          borderRadius: isBorderRadius 
          ? BorderRadius.circular(sizeBorderRadius)
          : null
        ),
        child: isLoading 
        ? Center(
            child: SpinKitFadingCircle(
              color: loadingColor,
              size: 25.0
            ),
          )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPrefixIcon ? const SizedBox(width: 15,) : Container(),
            isPrefixIcon
              ? prefixIcon!
              : Container(),
            isPrefixIcon ? const SizedBox(width: 15,) : Container(),
            customText
              ? text!
              : Center(
                child: Text(btnTxt ?? "...",
                  style: sfProRegular.copyWith(
                    color: btnTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ) 
                ),
              ),
          ],
        )
      ),
    );
  }
}
