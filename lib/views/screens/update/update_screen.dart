import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/utils/custom_themes.dart';
import 'package:ppidunia/utils/dimensions.dart';
import 'package:ppidunia/views/basewidgets/button/custom.dart';
import 'package:ppidunia/views/screens/update/update_screen_model.dart';
import 'package:ppidunia/views/screens/update/update_state.dart';

class UpdateScreenState extends State<UpdateScreen> {
  late UpdateScreenModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<UpdateScreenModel>();
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
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorResources.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [

                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Image.asset("assets/images/avatar/avatar-update.png",
                          width: 250.0,
                          height: 250.0,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(getTranslated('NEW_VERSION'),
                                style: sfProRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.black
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              if(Platform.isAndroid)
                                Text(getTranslated('NEW_VERSION_ANDROID'),
                                  style: sfProRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.black
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              if(Platform.isIOS)
                                Text(getTranslated('NEW_VERSION_IOS'),
                                  style: sfProRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.black
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: ColorResources.primary,
                      width: double.infinity,
                      child: CustomButton(
                        onTap: () async {
                          final newVersion = NewVersionPlus(
                            androidId: 'com.inovatif78.com.inovatif78.ppidunia',
                            iOSId: 'com.inovatif78.com.inovatif78.ppidunia'
                          );
                          if(Platform.isAndroid) {
                            newVersion.launchAppStore("https://play.google.com/store/apps/details?id=com.inovatif78.ppidunia");
                          } else {
                            // newVersion.launchAppStore("https://apps.apple.com/id/app/fspmi/id1639982534");
                          }
                        },
                        height: 65,
                        isBorderRadius: false,
                        isBorder: false,
                        isBoxShadow: false,
                        btnColor: ColorResources.primary,
                        customText: true,
                        text: Text("UPDATE",
                          style: sfProRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: ColorResources.white
                          ),
                        ),
                      ),
                    )
                  )

                ],
              );
            },
          )
        )
      ),
    );
  }
}