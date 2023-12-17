import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/consts/assets_const.dart';

import 'package:ppidunia/common/utils/color_resources.dart';

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}

class PermissionChecker extends StatefulWidget {
  const PermissionChecker({Key? key}) : super(key: key);

  @override
  PermissionCheckerState createState() => PermissionCheckerState();
}

class PermissionCheckerState extends State<PermissionChecker> {
  bool loading = false;

  late ServiceStatus serviceStatus;

  Future<void> listenForPermissionStatus() async {
    setState(() {
      loading = true;
    });
    var status = await Permission.location.status;
    if (status.isGranted) {
      serviceStatus = ServiceStatus.enabled;
      setState(() {
        loading = false;
      });
    } else if (status.isPermanentlyDenied) {
      serviceStatus = ServiceStatus.disabled;
      setState(() {
        loading = false;
      });
    } else {
      serviceStatus = ServiceStatus.disabled;
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> permissionNotification() async {
    try {
      PermissionStatus statusStorage = await Permission.notification.status;
      if (!statusStorage.isGranted) {
        await Permission.notification.request();
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    // try {
    //   setState(() {
    //     loading = true;
    //   });
    //   var status = await Permission.notification.status;
    //   if (status.isGranted) {
    //     serviceStatus = ServiceStatus.enabled;
    //     setState(() {
    //       loading = false;
    //     });
    //   } else if (status.isPermanentlyDenied) {
    //     Permission.notification.request();
    //     serviceStatus = ServiceStatus.disabled;
    //     setState(() {
    //       loading = false;
    //     });
    //   } else {
    //     serviceStatus = ServiceStatus.disabled;
    //     setState(() {
    //       loading = false;
    //     });
    //   }
    //   await Permission.notification.isDenied.then((value) {
    //     if (value) {
    //       Permission.notification.request();
    //     }
    //   });
    //   PermissionStatus statusStorage = await Permission.notification.status;
    //   if (statusStorage.isGranted) {
    //     await Permission.notification.request();
    //   }
    //   setState(() {
    //     loading = false;
    //   });
    // } catch (e, stacktrace) {
    //   debugPrint(stacktrace.toString());
    // }
  }

  @override
  void initState() {
    super.initState();

    permissionNotification();
    listenForPermissionStatus();
  }

  Future<void> onGotItClicked() async {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.bgSecondaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: screenSize.width / 2,
              child: Image.asset(AssetsConst.imageLogoPpi),
            ),
            const SizedBox(height: 30),
            !loading
                ? Container(
                    width: screenSize.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 15),
                        decoration: BoxDecoration(
                          color: ColorResources.success,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Location not found",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Turn on location",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 50,
                              width: screenSize.width,
                              child: TextButton(
                                onPressed: () => onGotItClicked(),
                                child: const Text(
                                  "Got it",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
