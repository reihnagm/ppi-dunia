import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/features/profil/presentation/widgets/generate_card.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:provider/provider.dart';

Widget profileCard({
  required BuildContext context,
  required ProfileProvider pp,
}) {
  final width = MediaQuery.of(context).size.width;
  print('Width : $width');
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    child: Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AssetsConst.imageIcCardDefault,
                  width: double.infinity,
                  height: 224.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              right: width < 400 ? 10 : 10,
              top: width < 400 ? 60 : 60,
              child: SizedBox(
                width: width < 400 ? 170 : 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        context.read<ProfileProvider>().pd.fullname != ""
                            ? context
                                .read<ProfileProvider>()
                                .pd
                                .fullname!
                                .toUpperCase()
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
                    ),
                    context.read<ProfileProvider>().pd.country!.name !=
                            "Indonesia"
                        ? Text(
                            '${context.read<ProfileProvider>().pd.position?.toUpperCase()} PPI ${context.read<ProfileProvider>().pd.country!.name?.toUpperCase() ?? "-"}',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeDefault,
                              fontFamily: 'SF Pro',
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            Positioned(
              right: width < 400 ? 10 : 10,
              bottom: 20,
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
                        width: width < 400 ? 140 : 170,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            context.read<ProfileProvider>().pd.email != ""
                                ? context.read<ProfileProvider>().pd.email!
                                : "-",
                            style: const TextStyle(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro',
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),
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
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => generateCard(pp: pp, context: context),
              child: Row(
                children: [
                  const Icon(
                    Icons.download,
                    size: 20,
                    color: ColorResources.white,
                  ),
                  Text(
                    getTranslated("DOWNLOAD_CARD"),
                    style: const TextStyle(color: ColorResources.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
