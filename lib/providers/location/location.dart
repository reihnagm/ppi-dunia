import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ppidunia/utils/shared_preferences.dart';

import 'package:ppidunia/maps/google_maps_place_picker.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider();

  GoogleMapController? googleMapC; 
  GoogleMapController? googleMapCCheckIn; 

  Future<void> getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      SharedPrefs.writeLatLng(position.latitude, position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      SharedPrefs.writeCurrentAddress("${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    } 
  }

  Future<void> updateCurrentPosition(BuildContext context, PickResult position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.geometry!.location.lat, position.geometry!.location.lng);
      Placemark place = placemarks[0]; 
      SharedPrefs.writeLatLng(
        position.geometry!.location.lat,
        position.geometry!.location.lng,
      );
      SharedPrefs.writeCurrentAddress("${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  String get getCurrentNameAddress => SharedPrefs.getCurrentNameAddress(); 

  double get getCurrentLat => SharedPrefs.getLat();
  
  double get getCurrentLng => SharedPrefs.getLng();
}