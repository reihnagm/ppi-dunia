import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as l;

import 'package:permission_handler/permission_handler.dart';

import 'package:ppidunia/utils/color_resources.dart';

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({
    required this.latitude, 
    required this.longitude
  });
}

class LocationService {
  late UserLocation currentLocation;
  l.Location location = l.Location();

  StreamController<UserLocation> locationC = StreamController<UserLocation>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == l.PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          locationC.add(UserLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
          ));
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => locationC.stream;
}

class PermissionChecker extends StatefulWidget {
  const PermissionChecker({Key? key}) : super(key: key);

  @override
  _PermissionCheckerState createState() => _PermissionCheckerState();
}

class _PermissionCheckerState extends State<PermissionChecker> {
  bool loading = false;

  late ServiceStatus serviceStatus;

  Future<void> listenForPermissionStatus() async {
    setState(() {
      loading = true;
    });
    var status = await Permission.location.status;
    if(status.isGranted) {
      serviceStatus = ServiceStatus.enabled;
      setState(() {
        loading = false;
      });
    } else if(status.isPermanentlyDenied) {
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

  @override
  void initState() {
    super.initState();
    
    listenForPermissionStatus();
  }

  Future<void> onGotItClicked() async {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark
      )
    );
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.bgSecondaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: screenSize.width / 2,
              child: Image.asset("assets/images/logo/logo.png"),
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
                      left: 10, right: 10, 
                      top: 20, bottom: 15
                    ),
                    decoration: BoxDecoration(
                      color: ColorResources.success,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Location not found",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w800
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("Turn on location",
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
                            child: const Text("Got it",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
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


