import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ppidunia/views/screens/location/get_location.dart';

abstract class GetLocationViewModel extends State<GetLocation> with SingleTickerProviderStateMixin {

  Completer<GoogleMapController> controller = Completer();
  TextEditingController searchController = TextEditingController();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Placemark> placemark = List<Placemark>.empty(growable: true);

  late GoogleMapController kcontroller;

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(-6.175392, 106.827153),
    zoom: 0,
  );

  Marker? marker;

  bool loading = true;
  bool hide = false;
  bool isLocationServiceEnabled = false;

  bool searchbar = false;
  String idLocation = "";

  Future<void> checkLocation() async {
    setState(() {
      loading = true;
    });
    try {
      kcontroller = await controller.future;
      geolocator.Position? position = await geolocator.Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);

      const MarkerId markerId = MarkerId('1');
      List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        marker = Marker(
          markerId: markerId,
          position: LatLng(
            position.latitude, 
            position.longitude
          ),
          anchor: const Offset(0.5, 1.5),
        );
        markers[markerId] = marker!;
        placemark = placemark;
      });

      prefs.setDouble("lat", position.latitude);
      prefs.setDouble("lng", position.longitude);

      CameraPosition goPosition = CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 18.151926040649414
      );

      kcontroller.animateCamera(CameraUpdate.newCameraPosition(goPosition));
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void hideSeek() {
    setState(() {
      hide = !hide;
    });
  }

  Future<void> loader() async {
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        loading = false;
      });
    });

    await checkLocation();
  }

  Future<void> onSubmitLocation() async {
    await geolocator.Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);
    // Navigate Push Replacement
  }

  Future<void> onSkip() async {
    // Navigate Push Replacement
  }

  Future<void> listenForPermissionStatus() async {
    final Future<ServiceStatus> serviceStatus = LocationPermissions().checkServiceStatus();

    serviceStatus.then((ServiceStatus serviceStatus) {
      if (serviceStatus == ServiceStatus.enabled) {
        setState(() {
          isLocationServiceEnabled = true;
        });
      }
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listenForPermissionStatus();
    checkLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loader();
    });
  }

}
