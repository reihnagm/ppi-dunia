
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:ppidunia/common/utils/global.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:geolocator/geolocator.dart';

import 'package:ppidunia/container.dart' as core;

import 'package:firebase_core/firebase_core.dart';

import 'package:ppidunia/providers.dart';

import 'package:ppidunia/services/firebase.dart';
import 'package:ppidunia/services/notification.dart';

import 'package:ppidunia/features/splash/presentation/pages/splash_state.dart';

import 'package:ppidunia/features/language/data/models/language.dart';

import 'package:ppidunia/localization/app_localization.dart';
import 'package:ppidunia/localization/localization.dart';

import 'package:ppidunia/common/consts/api_const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await core.init();
  await SharedPrefs.initSharedPreferences();
  runApp(MultiProvider(
    providers: providers,
    child: DevicePreview(
        enabled: false, builder: (BuildContext context) => const MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<void> getData() async {
    NotificationService.init(context);
    await Geolocator.requestPermission();
    if (mounted) {
      context.read<FirebaseProvider>().setupInteractedMessage(context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    /* Lifecycle */
    // - Resumed (App in Foreground)
    // - Inactive (App Partially Visible - App not focused)
    // - Paused (App in Background)
    // - Detached (View Destroyed - App Closed)
    if (state == AppLifecycleState.resumed) {
      debugPrint("=== APP RESUME ===");
      // if (!mounted) return;
      // navigatorKey.currentContext!
      //     .read<NotificationNotifier>()
      //     .checkNotification();
      // if (!mounted) return;
      // navigatorKey.currentContext!.read<LocationProvider>().checkLocation();
    }
    if (state == AppLifecycleState.inactive) {
      debugPrint("=== APP INACTIVE ===");
    }
    if (state == AppLifecycleState.paused) {
      debugPrint("=== APP PAUSED ===");
    }
    if (state == AppLifecycleState.detached) {
      debugPrint("=== APP CLOSED ===");
    }
  }

  void listenOnClickNotifications() =>
      NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(payload) {
    // var result = '${json.decode(payload)}';
    // debugPrint(result);
    // final String? payload = notificationResponse.payload;
    // print("Payloadnya adalah : ${payload}");
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    getData();
    context.read<FirebaseProvider>().listenNotification(context);
    listenOnClickNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (LanguageModel language in ApiConsts.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(360, 690),
      builder: (context, child) {
        ScreenUtil.init(context);
        return Portal(
          child: MaterialApp(
            title: 'PPI Dunia',
            debugShowCheckedModeBanner: false,
            locale: context.watch<LocalizationProvider>().locale,
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            scaffoldMessengerKey: scaffoldKey,
            navigatorKey: navigatorKey,
            supportedLocales: locals,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
