import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ppidunia/features/feed/data/reposiotories/comment/reply.dart';
import 'package:ppidunia/features/feed/data/reposiotories/event.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_detail/comment_detail_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/post/create_post_screen_model.dart';
import 'package:ppidunia/features/notification/provider/notification.dart';
import 'package:ppidunia/features/notification/provider/storage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ppidunia/services/firebase.dart';

import 'package:ppidunia/features/location/presentation/providers/location.dart';
import 'package:ppidunia/features/banner/presentation/providers/banner.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';

import 'package:ppidunia/features/profil/data/repositories/profile.dart';
import 'package:ppidunia/features/auth/data/repositories/auth.dart';
import 'package:ppidunia/features/banner/data/repositories/banner.dart';

import 'package:ppidunia/features/inbox/data/repositories/inbox.dart';
import 'package:ppidunia/features/sos/data/repositories/sos.dart';
import 'package:ppidunia/features/bookmark/data/repositories/bookmark.dart';
import 'package:ppidunia/features/media/data/repositories/media.dart';
import 'package:ppidunia/features/firebase/data/repositories/firebase.dart';
import 'package:ppidunia/features/maintenance/data/repositories/maintenance.dart';

import 'package:ppidunia/localization/localization.dart';

import 'package:ppidunia/features/inbox/presentation/pages/inbox_screen_model.dart';
import 'package:ppidunia/features/legality/presentation/pages/privacy_policy/privacy_policy_screen_model.dart';
import 'package:ppidunia/features/legality/presentation/pages/terms_of_use/terms_of_use_screen_model.dart';
import 'package:ppidunia/features/sos/presentation/pages/sos_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/change_password/change_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/first_step_screen/forget_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/second_step_screen/new_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:ppidunia/features/comingsoon/presentation/pages/comingsoon_screen_model.dart';
import 'package:ppidunia/features/onboarding/presentation/pages/onboarding_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/first_step_screen/sign_up_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/second_step_screen/study_abroad_status_screen_model.dart';
import 'package:ppidunia/features/splash/presentation/pages/splash_screen_model.dart';
import 'package:ppidunia/features/update/presentation/pages/update_screen_model.dart';
import 'package:ppidunia/features/dashboard/presentation/pages/dashboard_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/bookmarks/bookmark_screen_model.dart';

import 'features/feed/data/reposiotories/comment/comment.dart';
import 'features/feed/data/reposiotories/feed.dart';

final getIt = GetIt.instance;

Future<void> init() async {
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
  getIt.registerLazySingleton(() => ReplyRepo(
        dioClient: null,
      ));
  getIt.registerLazySingleton(() => EventRepo(
        dioClient: null,
      ));

  //Provider
  getIt.registerFactory(() => FirebaseProvider(fr: getIt(), ism: getIt()));
  getIt.registerFactory(() => LocalizationProvider());
  getIt.registerFactory(() => NotificationNotifier());
  getIt.registerFactory(() => StorageNotifier());
  getIt.registerFactory(() => CommentDetailModel(rr: getIt(), fr: getIt(), pp: getIt()));
  getIt.registerFactory(() => EventScreenModel(er: getIt()));
  getIt.registerFactory(() => LocationProvider());
  getIt.registerLazySingleton(() => FeedScreenModel(fr: getIt()));
  getIt.registerLazySingleton(() => SosScreenModel(sr: getIt(), lp: getIt()));
  getIt.registerLazySingleton(
      () => CommentScreenModel(cr: getIt(), fr: getIt(), pp: getIt()));
  getIt.registerLazySingleton(
      () => BookmarkScreenModel(br: getIt(), fr: getIt()));
  getIt.registerLazySingleton(() => DashboardScreenModel());
  getIt.registerLazySingleton(
      () => CreatePostModel(fsm: getIt(), fr: getIt(), mr: getIt()));
  getIt.registerLazySingleton(() => SplashScreenModel(mr: getIt()));
  getIt.registerLazySingleton(() => BannerProvider(br: getIt()));
  getIt.registerLazySingleton(
      () => ProfileProvider(pr: getIt(), fr: getIt(), mr: getIt()));
  getIt.registerLazySingleton(() => ComingSoonScreenModel());
  getIt.registerLazySingleton(() => UpdateScreenModel());
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
  getIt.registerLazySingleton(() => InboxScreenModel(ir: getIt()));
  getIt.registerLazySingleton(() => SignUpScreenModel(
        ar: getIt(),
      ));
  getIt.registerLazySingleton(() => StudyAbroadStatusScreenModel(
        ar: getIt(),
      ));
  getIt.registerLazySingleton(() => OtpScreenModel(
        ar: getIt(),
      ));
  getIt.registerLazySingleton(() => TermsOfUseScreenModel());
  getIt.registerLazySingleton(() => PrivacyPolicyScreenModel());

  //External
  SharedPreferences sp = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sp);
  getIt.registerLazySingleton(() => Dio());
}
