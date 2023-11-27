import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:ppidunia/common/utils/global.dart';

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
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Container(
            width: 300.h,
            height: 350.h,
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
                Text(
                  "Apakah Kamu yakin ingin lapor ?",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 11.0.sp, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text('Batal'))),
                    const SizedBox(width: 30.0),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text('Ok'))),
                  ],
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
