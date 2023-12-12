import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/features/profil/presentation/widgets/generate_card.dart';
import 'package:provider/provider.dart';

Widget profileCard({
  required BuildContext context,
  required ProfileProvider pp,
}) {
  final width = MediaQuery.of(context).size.width;
  print('Width : $width');
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.bottomCenter,
    children: [
      Image.asset(
        AssetsConst.imageIcCardDefault,
        width: double.infinity,
        height: 300.0,
      ),
      Positioned(
        right: width < 400 ? 5 : 20,
        bottom: 62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  AssetsConst.imageIcEmail,
                  width: 30.0,
                  height: 30.0,
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    context.read<ProfileProvider>().pd.email != ""
                        ? context.read<ProfileProvider>().pd.email!
                        : "-",
                    style: const TextStyle(
                      color: ColorResources.white,
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'SF Pro',
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  AssetsConst.imageIcPhone,
                  width: 30.0,
                  height: 30.0,
                ),
                Text(
                  context.read<ProfileProvider>().pd.phone != ""
                      ? context.read<ProfileProvider>().pd.phone!
                      : "-",
                  style: const TextStyle(
                    color: ColorResources.white,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        left: width < 400 ? 150 : 190,
        top: width < 400 ? 100 : 90,
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.read<ProfileProvider>().pd.fullname != ""
                    ? context.read<ProfileProvider>().pd.fullname!.toUpperCase()
                    : "-",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ColorResources.white,
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              ),
              context.read<ProfileProvider>().pd.country!.name != "Indonesia"
                  ? Text(
                      '${context.read<ProfileProvider>().pd.position} PPI ${context.read<ProfileProvider>().pd.country!.name?.toUpperCase() ?? "-"}',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro',
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      Positioned(
        right: 20,
        bottom: 210,
        child: GestureDetector(
          onTap: () => generateCard(pp: pp, context: context),
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.20),
            ),
            child: const Icon(
              Icons.download,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
      )
    ],
  );
}
