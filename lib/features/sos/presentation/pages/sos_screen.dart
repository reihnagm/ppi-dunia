import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/services/navigation.dart';

import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

import 'package:ppidunia/views/basewidgets/dialog/animated/animated.dart';
import 'package:ppidunia/features/sos/presentation/pages/sos_screen_model.dart';

import 'package:ppidunia/features/sos/presentation/pages/sos_state.dart';

class SosScreenState extends State<SosScreen> {
  late SosScreenModel ssm;

  @override
  void initState() {
    super.initState();

    ssm = context.read<SosScreenModel>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          backgroundColor: ColorResources.bgSecondaryColor,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    backgroundColor: ColorResources.transparent,
                    title: Container(),
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                  ),
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                          child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Center(
                              child: Text(
                                "What's the\nEmergency ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorResources.white,
                                    fontSize: Dimensions.fontSizeOverLarge,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'SF Pro'),
                              ),
                            ),
                            const SizedBox(height: 50.0),
                            sosWidget('ic-vehicle.png', 'Vehicle Issue',
                                'I need help, an incident has occurred'),
                            const SizedBox(height: 35.0),
                            sosWidget('ic-injury.png', 'Sickness or Injury',
                                'I need help, an incident has occurred'),
                            const SizedBox(height: 35.0),
                            sosWidget('ic-crime.png', 'Crime',
                                'I need help, an incident has occurred'),
                            const SizedBox(height: 35.0),
                            sosWidget('ic-lost.png', 'Lost or Trapped',
                                'I need help, an incident has occurred'),
                            const SizedBox(height: 35.0),
                            sosWidget('ic-fire.png', 'Fire',
                                'I need help, an incident has occurred'),
                          ],
                        ),
                      )))
                ],
              );
            },
          )),
    );
  }

  Widget sosWidget(String img, String title, String message) {
    return Container(
      width: 250.0,
      decoration: BoxDecoration(
          color: ColorResources.greyLight,
          borderRadius: BorderRadius.circular(12.0)),
      child: Material(
        color: ColorResources.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            showAnimatedDialog(
              context,
              Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 200,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorResources.black, width: 2),
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0))),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20.0),
                          Center(
                            child: Text(
                              "${getTranslated("ARE_YOU_SURE_WANT_BROADCAST_EVIDENCE")} $title ?",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: ColorResources.greyDarkPrimary,
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro'),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
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
                                          color: ColorResources.greyDarkPrimary,
                                          fontSize: Dimensions.fontSizeLarge,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SF Pro'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                InkWell(
                                  onTap: () async {
                                    await ssm.sendSos(context,
                                        title: title, message: message);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      getTranslated("YES"),
                                      style: const TextStyle(
                                          color: ColorResources.greyDarkPrimary,
                                          fontSize: Dimensions.fontSizeLarge,
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
                      Positioned(
                        bottom: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetsConst.imageIcPopUpSos,
                              width: 270,
                              height: 270,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(width: 30.0),
                Image.asset(
                  'assets/images/icons/$img',
                  width: 30.0,
                  height: 30.0,
                ),
                const SizedBox(width: 20.0),
                Text(title,
                    style: const TextStyle(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
