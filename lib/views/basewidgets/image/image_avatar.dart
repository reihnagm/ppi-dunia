import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/assets_const.dart';

Widget imageAvatar(String image, double radius) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      );
    },
    placeholder: (BuildContext context, String url) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Color(0xFF637687),
      );
    },
    errorWidget: (BuildContext context, String url, dynamic error) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage(AssetsConst.imageDefaultAva),
      );
    },
  );
}
