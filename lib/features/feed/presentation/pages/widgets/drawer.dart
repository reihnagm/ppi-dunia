import 'package:flutter/material.dart';
import 'package:ppidunia/common/consts/assets_const.dart';
import 'package:ppidunia/common/utils/modals.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_state.dart';
import 'package:provider/provider.dart';

import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

import 'package:ppidunia/localization/language_constraints.dart';

import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/common/utils/color_resources.dart';
import 'package:ppidunia/common/utils/dimensions.dart';

import 'package:ppidunia/services/navigation.dart';

class DrawerScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> gk;
  const DrawerScreen({required this.gk, super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  late SignInScreenModel ssm;

  @override
  void initState() {
    super.initState();

    ssm = context.read<SignInScreenModel>();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 20,
            ),
            // Container(
            //   margin: const EdgeInsets.only(
            //       top: 20.0, bottom: 10.0, right: 25.0, left: 25.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       Text(
            //         getTranslated("LANGUAGE"),
            //         style: const TextStyle(
            //             color: ColorResources.greyDarkPrimary,
            //             fontSize: Dimensions.fontSizeDefault,
            //             fontWeight: FontWeight.w400,
            //             fontFamily: 'SF Pro'),
            //       ),
            //       const SizedBox(width: 10.0),
            //       Consumer<LocalizationProvider>(
            //         builder: (BuildContext context,
            //             LocalizationProvider localizationProvider,
            //             Widget? child) {
            //           return FlutterSwitch(
            //             showOnOff: false,
            //             width: 80.0,
            //             height: 35.0,
            //             valueFontSize: 20.0,
            //             toggleSize: 30.0,
            //             borderRadius: 30.0,
            //             padding: 5.0,
            //             value: localizationProvider.isIndonesian,
            //             inactiveColor: ColorResources.grey,
            //             activeColor: ColorResources.primaryOrange,
            //             onToggle: (bool val) {
            //               localizationProvider.toggleLanguage();
            //             },
            //           );
            //         },
            //       )
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () {
                GeneralModal.showConfirmModals(
                  image: AssetsConst.imageIcPopUpLogout,
                  msg: getTranslated("ARE_YOU_SURE_WANT_DELETE_AN_ACCOUNT"),
                  onPressed: () async {
                    await Provider.of<ProfileProvider>(context, listen: false)
                        .deleteAccount();
                    widget.gk.currentState!.closeDrawer();
                    SharedPrefs.deleteData();
                    NS.pushReplacement(context, const SignInScreen());
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      getTranslated("DELETE_ACCOUNT"),
                      style: const TextStyle(
                          color: ColorResources.greyDarkPrimary,
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro'),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                GeneralModal.showConfirmModals(
                  image: AssetsConst.imageIcPopUpLogout,
                  msg: getTranslated("ARE_YOU_SURE_WANT_LOGOUT"),
                  onPressed: () async {
                    widget.gk.currentState!.closeDrawer();
                    ssm.logout(context);
                    SharedPrefs.deleteData();
                    NS.pushReplacement(context, const SignInScreen());
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      getTranslated("LOGOUT"),
                      style: const TextStyle(
                          color: ColorResources.greyDarkPrimary,
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
