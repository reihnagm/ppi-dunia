import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ppidunia/services/firebase.dart';
import 'package:ppidunia/services/location.dart';

import 'package:ppidunia/providers/location/location.dart';
import 'package:ppidunia/providers/banner/banner.dart';
import 'package:ppidunia/providers/profile/profile.dart';

import 'package:ppidunia/data/repository/profile/profile.dart';
import 'package:ppidunia/data/repository/auth/auth.dart';
import 'package:ppidunia/data/repository/banner/banner.dart';
import 'package:ppidunia/data/repository/feed/comment/comment.dart';

import 'package:ppidunia/data/repository/inbox/inbox.dart';
import 'package:ppidunia/data/repository/sos/sos.dart';
import 'package:ppidunia/data/repository/bookmark/bookmark.dart';
import 'package:ppidunia/data/repository/feed/feed.dart';
import 'package:ppidunia/data/repository/media/media.dart';
import 'package:ppidunia/data/repository/firebase/firebase.dart';
import 'package:ppidunia/data/repository/maintenance/maintenance.dart';

import 'package:ppidunia/localization/localization.dart';

import 'package:ppidunia/views/screens/inbox/inbox_screen_model.dart';
import 'package:ppidunia/views/screens/legality/privacy_policy/privacy_policy_screen_model.dart';
import 'package:ppidunia/views/screens/legality/terms_of_use/terms_of_use_screen_model.dart';
import 'package:ppidunia/views/screens/sos/sos_screen_model.dart';
import 'package:ppidunia/views/screens/auth/change_password/change_password_screen_model.dart';
import 'package:ppidunia/views/screens/auth/forget_password/first_step_screen/forget_password_screen_model.dart';
import 'package:ppidunia/views/screens/auth/forget_password/second_step_screen/new_password_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:ppidunia/views/screens/comingsoon/comingsoon_screen_model.dart';
import 'package:ppidunia/views/screens/onboarding/onboarding_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_in/sign_in_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_up/first_step_screen/sign_up_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_up/second_step_screen/study_abroad_status_screen_model.dart';
import 'package:ppidunia/views/screens/splash/splash_screen_model.dart';
import 'package:ppidunia/views/screens/update/update_screen_model.dart';
import 'package:ppidunia/views/screens/dashboard/dashboard_screen_model.dart';
import 'package:ppidunia/views/screens/feed/comment/comment_screen_model.dart';
import 'package:ppidunia/views/screens/feed/bookmarks/bookmark_screen_model.dart';
import 'package:ppidunia/views/screens/feed/feed/feed_screen_model.dart';
import 'package:ppidunia/views/screens/feed/post/create_post_screen_model.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => LocationService());

  //Api
  getIt.registerLazySingleton(() => AuthRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => ProfileRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => FeedRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => MaintenanceRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => InboxRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => FirebaseRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => SosRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => BannerRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => MediaRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => BookmarkRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => CommentRepo(
    dioClient: null,
  ));

  //Provider
  getIt.registerFactory(() => FirebaseProvider(
    fr: getIt(),
    ism: getIt()
  ));
  getIt.registerFactory(() => LocalizationProvider( ));
  getIt.registerFactory(() => LocationProvider( ));
  getIt.registerLazySingleton(() => FeedScreenModel(
    fr: getIt()
  ));
  getIt.registerLazySingleton(() => SosScreenModel(
    sr: getIt(),
    lp: getIt()
  ));
  getIt.registerLazySingleton(() => CommentScreenModel(
    cr: getIt(),
    fr: getIt(),
    pp: getIt()
  ));
  getIt.registerLazySingleton(() => BookmarkScreenModel(
    br: getIt(),
    fr: getIt()
  ));
  getIt.registerLazySingleton(() => DashboardScreenModel());
  getIt.registerLazySingleton(() => CreatePostModel(
    fsm: getIt(),
    fr: getIt(),
    mr: getIt()
  ));
  getIt.registerLazySingleton(() => SplashScreenModel(mr: getIt()));
  getIt.registerLazySingleton(() => BannerProvider(
    br: getIt()
  ));
  getIt.registerLazySingleton(() => ProfileProvider(
    pr: getIt(),
    fr: getIt(),
    mr: getIt()
  ));
  getIt.registerLazySingleton(() => ComingSoonScreenModel(
  ));
  getIt.registerLazySingleton(() => UpdateScreenModel(
  ));
  getIt.registerLazySingleton(() => OnboardingScreenModel());
  getIt.registerLazySingleton(() => SignInScreenModel(
    ar: getIt(),
  ));
  getIt.registerLazySingleton(() => ForgetPasswordScreenModel(
    ar: getIt(),
  ));
  getIt.registerLazySingleton(() => ChangePasswordScreenModel(
    ar: getIt(),
  ));
  getIt.registerLazySingleton(() => NewPasswordScreenModel(
    ar: getIt(),
  ));
  getIt.registerLazySingleton(() => InboxScreenModel(
    ir: getIt()
  ));
  getIt.registerLazySingleton(() => SignUpScreenModel(
    ar: getIt(),
  ));
  getIt.registerLazySingleton(() => StudyAbroadStatusScreenModel(
    ar: getIt(),
  ));
  getIt.registerLazySingleton(() => OtpScreenModel(
    ar: getIt(),
  ));
  getIt.registerLazySingleton(() => TermsOfUseScreenModel(
  ));
  getIt.registerLazySingleton(() => PrivacyPolicyScreenModel(
  ));

  
  //External
  SharedPreferences sp = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sp);
  getIt.registerLazySingleton(() => Dio());
}