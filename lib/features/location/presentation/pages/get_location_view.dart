import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';

import 'package:ppidunia/views/basewidgets/search/search_bar.dart' as sb;

import 'package:ppidunia/services/location.dart';

import 'package:ppidunia/common/utils/color_resources.dart';

import 'package:ppidunia/features/location/presentation/pages/get_location_view_model.dart';

class GetLocationView extends GetLocationViewModel {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: ColorResources.greyLightPrimary,
        systemNavigationBarIconBrightness: Brightness.dark));

    final screenSize = MediaQuery.of(context).size;
    return !isLocationServiceEnabled
        ? const PermissionChecker()
        : Scaffold(
            body: Stack(children: [
            SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: kGooglePlex,
                onMapCreated: (GoogleMapController theController) {
                  controller.complete(theController);
                },
                markers: Set<Marker>.of(markers.values),
              ),
            ),
            AnimatedOpacity(
                opacity: loading ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  color: ColorResources.bgSecondaryColor.withOpacity(0.7),
                  child: Center(
                      child: Loading(
                          indicator: LineScalePulseOutIndicator(),
                          size: 100.0)),
                )),
            AnimatedPositioned(
              bottom: hide ? -160 : 0,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 250),
              child: AnimatedOpacity(
                opacity: loading ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 250),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10, right: 15),
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                blurRadius: 8.0,
                                spreadRadius: 2.0,
                                offset: const Offset(
                                  0.0,
                                  0.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(10.0)),
                        child: InkWell(
                          onTap: () => hideSeek(),
                          child: hide
                              ? const Icon(Icons.arrow_upward)
                              : const Icon(Icons.arrow_downward),
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 150),
                        margin: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                blurRadius: 8.0,
                                spreadRadius: 5.0,
                                offset: const Offset(
                                  0.0,
                                  4.0,
                                ),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            searchbar
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: sb.SearchBar(
                                      color: ColorResources.success,
                                      bgColor: ColorResources.success
                                          .withOpacity(0.1),
                                      hint: "Search For Location",
                                      controller: searchController,
                                    ),
                                  )
                                : const SizedBox(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Current Location",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_pin,
                                    color: ColorResources.blue),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: Text(
                                    loading || placemark.isEmpty
                                        ? "Waiting..."
                                        : Platform.isIOS
                                            ? placemark[0].locality! +
                                                ", " +
                                                placemark[0].country!
                                            : placemark[0]
                                                    .subAdministrativeArea! +
                                                ", " +
                                                placemark[0].country!,
                                    style: const TextStyle(
                                        color: ColorResources.blue,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25.0),
                            SizedBox(
                              width: screenSize.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  backgroundColor: ColorResources.success,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                                onPressed: () => onSubmitLocation(),
                                child: const Text(
                                  "Use Location",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            widget.mode == 'home'
                ? const SizedBox()
                : Positioned(
                    top: 50.0,
                    right: -10.0,
                    child: SizedBox(
                        width: 80.0,
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.success,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0))),
                          ),
                          onPressed: () => onSkip(),
                          child: const Text(
                            "Skip",
                          ),
                        ))),
          ]));
  }
}
