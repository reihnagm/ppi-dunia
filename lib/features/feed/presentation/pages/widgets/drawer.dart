import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/localization/localization.dart';

import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/views/basewidgets/dialog/animated/animated.dart';

class DrawerScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> gk;
  const DrawerScreen({required this.gk, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 20,
            ),
            // Container(
            //   margin: const EdgeInsets.only(
            //       top: 20.0, bottom: 10.0, right: 25.0, left: 25.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       Text(
            //         getTranslated("LANGUAGE"),
            //         style: const TextStyle(
            //             color: ColorResources.greyDarkPrimary,
            //             fontSize: Dimensions.fontSizeDefault,
            //             fontWeight: FontWeight.w400,
            //             fontFamily: 'SF Pro'),
            //       ),
            //       const SizedBox(width: 10.0),
            //       Consumer<LocalizationProvider>(
            //         builder: (BuildContext context,
            //             LocalizationProvider localizationProvider,
            //             Widget? child) {
            //           return FlutterSwitch(
            //             showOnOff: false,
            //             width: 80.0,
            //             height: 35.0,
            //             valueFontSize: 20.0,
            //             toggleSize: 30.0,
            //             borderRadius: 30.0,
            //             padding: 5.0,
            //             value: localizationProvider.isIndonesian,
            //             inactiveColor: ColorResources.grey,
            //             activeColor: ColorResources.primaryOrange,
            //             onToggle: (bool val) {
            //               localizationProvider.toggleLanguage();
            //             },
            //           );
            //         },
            //       )
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () {
                showAnimatedDialog(
                    context,
                    Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20.0),
                              Center(
                                child: Text(
                                  getTranslated(
                                      "ARE_YOU_SURE_WANT_DELETE_AN_ACCOUNT"),
                                  style: const TextStyle(
                                      color: ColorResources.greyDarkPrimary,
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'SF Pro'),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        NS.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getTranslated("NO"),
                                          style: const TextStyle(
                                              color: ColorResources
                                                  .greyDarkPrimary,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'SF Pro'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    InkWell(
                                      onTap: () async {
                                        await Provider.of<ProfileProvider>(
                                                context,
                                                listen: false)
                                            .deleteAccount();
                                        gk.currentState!.closeDrawer();
                                        SharedPrefs.deleteData();
                                        NS.pushReplacement(
                                            context, const SignInScreen());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getTranslated("YES"),
                                          style: const TextStyle(
                                              color: ColorResources
                                                  .greyDarkPrimary,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'SF Pro'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      getTranslated("DELETE_ACCOUNT"),
                      style: const TextStyle(
                          color: ColorResources.greyDarkPrimary,
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro'),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showAnimatedDialog(
                  context,
                  Dialog(
                    child: Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 200,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ColorResources.black, width: 2),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0))),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(height: 80.0),
                              Center(
                                child: Text(
                                  getTranslated("ARE_YOU_SURE_WANT_LOGOUT"),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: ColorResources.black,
                                      fontSize: Dimensions.fontSizeExtraLarge,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SF Pro'),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: -45,
                            child: Container(
                              width: MediaQuery.sizeOf(context).width > 400
                                  ? 275
                                  : 265,
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      NS.pop(context);
                                    },
                                    style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 40)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ColorResources.pinkWoman),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      getTranslated("NO").toUpperCase(),
                                      style: const TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SF Pro'),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      print('Click');
                                      gk.currentState!.closeDrawer();
                                      SharedPrefs.deleteData();
                                      NS.pushReplacement(
                                          context, const SignInScreen());
                                    },
                                    style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 40)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ColorResources.redHealth),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      getTranslated("YES").toUpperCase(),
                                      style: const TextStyle(
                                          color: ColorResources.white,
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'SF Pro'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AssetsConst.imageIcPopUpLogout,
                                  width: 270,
                                  height: 270,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      getTranslated("LOGOUT"),
                      style: const TextStyle(
                          color: ColorResources.greyDarkPrimary,
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
