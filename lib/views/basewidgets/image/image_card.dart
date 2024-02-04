import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:shimmer/shimmer.dart';

Widget imageCard(String image, double height, double radius) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (BuildContext context, ImageProvider imageProvider) {
      return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
                alignment: Alignment.centerLeft,
                fit: BoxFit.cover,
                image: imageProvider)),
      );
    },
    placeholder: (BuildContext context, String val) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[200]!,
        child: Card(
          margin: EdgeInsets.zero,
          color: ColorResources.white,
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: ColorResources.white),
          ),
        ),
      );
    },
    errorWidget: (BuildContext context, String text, dynamic _) {
      return Container(
        decoration: const BoxDecoration(
          color: ColorResources.backgroundColorPrimary,
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: Image.asset(
          AssetsConst.imageDefault,
          width: double.infinity,
          height: height,
          fit: BoxFit.contain,
        ),
      );
    },
  );
}
