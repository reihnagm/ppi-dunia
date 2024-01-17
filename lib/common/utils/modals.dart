import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';
import 'package:ppidunia/common/utils/global.dart';
import 'package:ppidunia/features/sos/presentation/pages/sos_screen_model.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:provider/provider.dart';

class GeneralModal {
  static Future<Object?> termsAndCondition() async {
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Container(
            width: 300.h,
            height: 650.h,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                LottieBuilder.asset(
                  'assets/lottie/info.json',
                  width: 200.0,
                  height: 200.0,
                ),
                Column(children: [
                  Text(
                    "I'ts important that you understand what",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "information PPI DUNIA collects.",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "● Your Information & Content",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "This may include any information you share with us,\nfor example; your create a post and another users\ncan like your post or comment also you can delete\nyour post.",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "● Photos, Videos & Documents",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "This may include your can post on media\nphotos, videos, or documents",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "● Embedded Links",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "This may include your can post on link\nsort of news, etc",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ]),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      Future.delayed(Duration.zero, () {
                        Navigator.pop(navigatorKey.currentContext!);
                      });
                    },
                    child: const Text('Ok'))
              ],
            ),
          )),
        );
      },
    );
  }

  static Future<void> reportUser() async {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 300.w,
                        height: 400.h,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                left: 20.w,
                                right: 20.w,
                                bottom: 20.h,
                                child: Container(
                                  height: 200.h,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Are you sure you want to report ?",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                              bottom: 0.0,
                              left: 60.w,
                              right: 60.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorResources.pinkWoman,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
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
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorResources.redHealth),
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
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Image.asset(
                                AssetsConst.imageIcPopUpLogout,
                                width: 250.0,
                                height: 250.0,
                              ),
                            ),
                          ],
                        ))
                  ]),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showConfirmModals({
    required String msg,
    required String image,
    String? titleYes,
    bool? isLoading,
    required Function() onPressed,
  }) async {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 300,
                        height:300,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                left: 20,
                                right: 20,
                                bottom: 20,
                                child: Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        msg,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                              bottom: 0.0,
                              left: 60,
                              right: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 4,
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          )
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorResources.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                        ),
                                        child: Text(
                                          getTranslated("NO").toUpperCase(),
                                          style: const TextStyle(
                                              color: ColorResources.redHealth,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'SF Pro'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: context
                                                  .watch<SosScreenModel>()
                                                  .sosStatus ==
                                              SosStatus.loading
                                          ? null
                                          : onPressed,
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorResources.redHealth),
                                      ),
                                      child: Text(
                                        context
                                                    .watch<SosScreenModel>()
                                                    .sosStatus ==
                                                SosStatus.loading
                                            ? "..."
                                            : getTranslated("YES")
                                                .toUpperCase(),
                                        style: const TextStyle(
                                            color: ColorResources.white,
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SF Pro'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Image.asset(
                                image,
                                width: 150.0,
                                height: 150.0,
                              ),
                            ),
                          ],
                        ))
                  ]),
            ),
          ),
        );
      },
    );
  }

  static Future<void> dialogRequestNotification({
    required String msg,
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 300.w,
                        height: 400.h,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                left: 20.w,
                                right: 20.w,
                                bottom: 20.h,
                                child: Container(
                                  height: 200.h,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        msg,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                                bottom: 0.0,
                                left: 80.w,
                                right: 80.w,
                                child: CustomButton(
                                  isBorder: false,
                                  btnColor: ColorResources.redHealth,
                                  btnTextColor: Colors.white,
                                  sizeBorderRadius: 20.0,
                                  isBorderRadius: true,
                                  height: 40.0,
                                  onTap: () async {
                                    await openAppSettings();
                                  },
                                  btnTxt: "Aktifkan",
                                )),
                            Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Image.asset(
                                AssetsConst.imageIcPopUpDelete,
                                width: 250.0,
                                height: 250.0,
                              ),
                            ),
                          ],
                        ))
                  ]),
            ),
          ),
        );
      },
    );
  }

  static Future<void> info({required String msg, required bool isBackHome}) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300.w,
                      height: 400.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                              left: 20.w,
                              right: 20.w,
                              bottom: 20.h,
                              child: Container(
                                height: 200.h,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Colors.white),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      msg,
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              )),
                          Positioned(
                              bottom: 0.0,
                              left: 80.w,
                              right: 80.w,
                              child: CustomButton(
                                isBorder: false,
                                btnColor: ColorResources.blueCar,
                                btnTextColor: Colors.white,
                                // fontSize: 13.sp,
                                sizeBorderRadius: 20.0,
                                isBorderRadius: true,
                                height: 40.0,
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context, false);
                                },
                                btnTxt: "OK",
                              )),
                          Positioned(
                            top: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Image.asset(
                              AssetsConst.imageIcPopUpDelete,
                              width: 250.0,
                              height: 250.0,
                            ),
                          ),
                        ],
                      ))
                ]),
          ),
        );
      },
    );
  }
}
