import 'package:flutter/material.dart';
import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/custom_themes.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

class CustomAppBar {
  final String title;
  final bool? fromHome;
  final bool? notTransparent;
  final List<Widget>? actions;
  final PreferredSize? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.bottom,
    this.fromHome,
    this.notTransparent,
  });

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorResources.primary,
      centerTitle: true,
      toolbarHeight: 80.0,
      title: Text(
        title,
        style: sfProRegular.copyWith(
          color: ColorResources.white,
          fontSize: Dimensions.fontSizeOverLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      leading: InkWell(
        onTap: () => NS.pop(context),
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border.all(color: ColorResources.transparent, width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
            child: IconButton(
                onPressed: () {
                  NS.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: Dimensions.iconSizeLarge,
                )),
          ),
        ),
      ),
      bottom: bottom,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: ColorResources.primary,
      toolbarHeight: 80.0,
      title: Text(
        title,
        style: sfProRegular.copyWith(
          color: ColorResources.white,
          fontSize: Dimensions.fontSizeOverLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      leading: fromHome == true
          ? Container()
          : InkWell(
              onTap: () => NS.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: ColorResources.transparent, width: 1.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                  child: IconButton(
                      onPressed: () {
                        NS.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: Dimensions.iconSizeLarge,
                      )),
                ),
              ),
            ),
      bottom: bottom,
    );
  }
}
