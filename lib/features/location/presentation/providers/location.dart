import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ppidunia/common/utils/modals.dart';

import 'package:ppidunia/common/utils/shared_preferences.dart';

import 'package:ppidunia/maps/google_maps_place_picker.dart';

class LocationProvider extends ChangeNotifier {
  NotificationNotifier() {
    isDialogShowing = false; // Prevent call twice
  }

  LocationProvider();

  GoogleMapController? googleMapC;
  GoogleMapController? googleMapCCheckIn;

  bool isDialogShowing = false;

  Future<void> initLocation() async {
    final loc = await Geolocator.requestPermission();

    if (loc == LocationPermission.whileInUse ||
        loc == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();

      SharedPrefs.writeLatLng(position.latitude, position.longitude);
    }
  }

  Future<void> getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      SharedPrefs.writeLatLng(position.latitude, position.longitude);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      SharedPrefs.writeCurrentAddress(
          "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> updateCurrentPosition(
      BuildContext context, PickResult position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.geometry!.location.lat, position.geometry!.location.lng);
      Placemark place = placemarks[0];
      SharedPrefs.writeLatLng(
        position.geometry!.location.lat,
        position.geometry!.location.lng,
      );
      SharedPrefs.writeCurrentAddress(
          "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> checkLocation() async {
    var locationRequest = await Permission.location.isDenied ||
        await Permission.location.isPermanentlyDenied;

    if (locationRequest) {
      if (!isDialogShowing) {
        isDialogShowing = true;
        await GeneralModal.dialogRequestNotification(
            msg: "Location feature needed, please activate your location");
      }
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        initLocation();
      });
    }

    notifyListeners();
  }

  String get getCurrentNameAddress => SharedPrefs.getCurrentNameAddress();

  void setLatLng(double lat, double lng) {
    SharedPrefs.writeLatLng(lat, lng);
  }

  double get getCurrentLat => SharedPrefs.getLat();

  double get getCurrentLng => SharedPrefs.getLng();
}
