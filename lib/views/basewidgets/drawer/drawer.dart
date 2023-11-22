//TODO: adjust to the project
// import 'package:ppidunia/providers/auth/auth.dart';
// import 'package:ppidunia/providers/profile/profile.dart';
// import 'package:ppidunia/views/basewidgets/dialog/custom/custom.dart';
// import 'package:ppidunia/views/screens/profile/profile.dart';
// import 'package:ppidunia/views/screens/settings/settings.dart';
// import 'package:ppidunia/views/screens/tos/tos.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import 'package:ppidunia/localization/language_constraints.dart';


// import 'package:ppidunia/services/navigation.dart';

// import 'package:ppidunia/utils/color_resources.dart';
// import 'package:ppidunia/utils/custom_themes.dart';
// import 'package:ppidunia/utils/dimensions.dart';

// import 'package:ppidunia/views/screens/auth/sign_in/sign_in.dart';
// import 'package:ppidunia/views/webview/webview.dart';

// class DrawerWidget extends StatefulWidget {
//   const DrawerWidget({ Key? key }) : super(key: key);

//   @override
//   State<DrawerWidget> createState() => _DrawerWidgetState();
// }

// class _DrawerWidgetState extends State<DrawerWidget> {

//   PackageInfo packageInfo = PackageInfo(
//     appName: 'Unknown',
//     packageName: 'Unknown',
//     version: 'Unknown',
//     buildNumber: 'Unknown',
//     buildSignature: 'Unknown',
//   );

//     Future<void> initPackageInfo() async {
//     PackageInfo info = await PackageInfo.fromPlatform();

//     setState(() {
//       packageInfo = info;
//     });
//   }

//   Future<void> getData() async {
//     if(mounted) {
//       await context.read<ProfileProvider>().getProfile(context);
//     }
//   }


//   @override
//   void initState() {
//     super.initState();

//     initPackageInfo();
//   }

//   @override 
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildUI();
//   }

//   Widget buildUI() {
//     return Drawer(
//       backgroundColor: ColorResources.transparent,
//       child: Container(
//         width: double.infinity,
//         decoration: buildDrawerBackground(),
//         padding: const EdgeInsets.only(top: Dimensions.marginSizeExtraLarge),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             buildBackButton(),
//             buildUserImage(),
//             const SizedBox(height: 30.0,),
//             buildAppVersion(),
//             buildScreenTiles(),
//           ],
//         )
//       ),
//     );
//   }

//   BoxDecoration buildDrawerBackground() {
//     return const BoxDecoration(
//       color: ColorResources.primary
//     );
//   }

//   Widget buildBackButton() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Padding(
//         padding: const EdgeInsets.only(right: Dimensions.marginSizeExtraLarge),
//         child: IconButton(
//           onPressed: () => NS.pop(context),
//           icon: const Icon(
//             Icons.arrow_forward_ios,
//             size: Dimensions.iconSizeDefault,
//             color: ColorResources.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildUserImage() {
//     return Align(
//       alignment: Alignment.center,
//       child: GestureDetector(
//         onTap: () {
//           context.read<ProfileProvider>().getUserRole() == "user"
//             ? CustomDialog().showWaitingApproval(context)  
//             : NS.push(context, const ProfileScreen());
//         },
//         child: Stack(
//           children: [ 
//             CircleAvatar(
//               radius: 92.0,
//               backgroundColor: ColorResources.white.withOpacity(0.2),
//               child: 
//               Consumer<ProfileProvider>(
//                   builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
//                     if(profileProvider.profileStatus == ProfileStatus.loading) {
//                       return const CircleAvatar(
//                         backgroundColor: ColorResources.white,
//                         backgroundImage: AssetImage("assets/images/logo/logo.png"),
//                         maxRadius: 80.0,
//                       );
//                     }
//                     if(profileProvider.profileStatus == ProfileStatus.error) {
//                       return const CircleAvatar(
//                         backgroundColor: ColorResources.white,
//                         backgroundImage: AssetImage("assets/images/logo/logo.png"),
//                         maxRadius: 80.0,
//                       );
//                     }
//                     return CachedNetworkImage(
//                       imageUrl: profileProvider.profile!.profilePic!,
//                       imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) {
//                         return CircleAvatar(
//                           backgroundColor: ColorResources.white,
//                           backgroundImage: imageProvider,
//                           maxRadius: 80.0,
//                         );
//                       },
//                       placeholder: (BuildContext context, String url) {
//                         return CircleAvatar(
//                           backgroundColor: ColorResources.white,
//                           maxRadius: 80.0,
//                           child: Image.asset("assets/images/logo/logo.png",),
//                         );
//                       },
//                       errorWidget: (BuildContext context, String url, dynamic error) {
//                         return CircleAvatar(
//                           backgroundColor: ColorResources.white,
//                           maxRadius: 80.0,
//                           child: Image.asset("assets/images/logo/logo.png",)
//                         );
//                       },
//                     );
//                   },
//                 )
//               ),
//             Positioned(
//               left: 120.0,
//               bottom: 6.0,
//               child: GestureDetector(
//                 onTap: () {
//                   context.read<ProfileProvider>().getUserRole() == "user"
//                     ? CustomDialog().showWaitingApproval(context)  
//                     : NS.push(context, const ProfileScreen());
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     boxShadow: kElevationToShadow[2]
//                   ),
//                   child: Image.asset(
//                     'assets/images/drawer/icon-edit.png',
//                     fit: BoxFit.contain,
//                     height: Dimensions.iconSizeDefault,
//                     width: Dimensions.iconSizeDefault,
//                   ),
//                 ),
//               ),
//             ),
//           ]
//         ),
//       ),
//     );
//   }

//   Widget buildAppVersion() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Padding(
//         padding: const EdgeInsets.only(right: Dimensions.marginSizeExtraLarge),
//         child: Text("${getTranslated("VERSION", context)} ${packageInfo.version}",
//           style: const TextStyle(
//             fontSize: Dimensions.fontSizeDefault,
//             color: ColorResources.white
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildScreenTiles() {
//     List screens = [
//       // {
//       //   "title": getTranslated("CASH_OUT", context),
//       //   "image": "icon-cash-white.png",
//       //   "link": ComingSoonScreen(title: getTranslated("CASH_OUT", context)),
//       // },
//       {
//         "title": getTranslated("SETTINGS", context),
//         "image": "icon-settings-white.png",
//         "link": const SettingsScreen(),
//       },
//       {
//         "title": getTranslated("TOS", context),
//         "image": "icon-tos-white.png",
//         "link": const TosScreen(),
//       },
//       {
//         "title": getTranslated("SUPPORT", context),
//         "image": "icon-cs-white.png",
//         "link": WebViewScreen(title: getTranslated("SUPPORT", context), url: 'https://cms-hog.inovasi78.com/mobile-support'),
//       },
//       {
//         "title": getTranslated("LOGOUT", context),
//         "image": "icon-logout-white.png",
//         "link": const SignInScreen(),
//       },
//     ];

//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: screens.length,
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (BuildContext context, int i) {
//         return Material(
//           color: ColorResources.transparent,
//           child: InkWell(
//             splashColor: ColorResources.primary,
//             onTap: () {
//               screens[i] == screens[3]
//                 ? buildSignOutPopup(context)
//                 : context.read<ProfileProvider>().getUserRole() == "user" || context.read<AuthProvider>().getUserRole().isEmpty
//                   ? CustomDialog().showWaitingApproval(context)
//                   : NS.push(context, screens[i]["link"]);
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(left: 40.0),
//               child: ListTile(
//                 leading: Image.asset(
//                   'assets/images/drawer/${screens[i]["image"]}',
//                   fit: BoxFit.fill,
//                   height: Dimensions.iconSizeLarge,
//                   width: Dimensions.iconSizeLarge,
//                 ),
//                 horizontalTitleGap: Dimensions.marginSizeExtraLarge,
//                 title: Text(screens[i]["title"],
//                   style: const TextStyle(
//                     fontSize: Dimensions.fontSizeLarge,
//                     color: ColorResources.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//     );
//   }

//   AwesomeDialog buildSignOutPopup(BuildContext context) {
//     return AwesomeDialog(
//       context: context,
//       animType: AnimType.scale,
//       dialogType: DialogType.question,
//       customHeader: Image.asset('assets/images/avatar/avatar-logout.png',
//         height: 160.0,
//         width: 160.0,
//         fit: BoxFit.fitHeight,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Text("Apakah anda yakin ingin melakukan LogOut?",
//           style: sfProRegular.copyWith(
//             color: ColorResources.black,
//             fontSize: Dimensions.fontSizeLarge,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       btnCancelText: 'Batal',
//       btnCancelColor: const Color(0xff11B1E4),
//       btnCancelOnPress: () { },
//       btnOkText: "Log Out",
//       btnOkColor: ColorResources.primary,
//       btnOkOnPress: () async {
//         context.read<AuthProvider>().logout(context);
//       },
//     )..show();
//   }


// }