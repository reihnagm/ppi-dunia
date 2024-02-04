import 'package:ppidunia/features/feed/presentation/pages/comment/comment_detail/comment_detail_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/comment/comment_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_detail/event_detail_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/event/event_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/feed/feed_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/post/create_post_screen_model.dart';
import 'package:ppidunia/features/location/presentation/providers/location.dart';
import 'package:ppidunia/features/notification/provider/notification.dart';
import 'package:ppidunia/features/notification/provider/storage.dart';
import 'package:ppidunia/features/profil/presentation/provider/profile.dart';
import 'package:ppidunia/features/banner/presentation/providers/banner.dart';
import 'package:ppidunia/features/legality/presentation/pages/privacy_policy/privacy_policy_screen_model.dart';
import 'package:ppidunia/features/legality/presentation/pages/terms_of_use/terms_of_use_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:ppidunia/services/firebase.dart';

import 'package:ppidunia/localization/localization.dart';

import 'package:ppidunia/features/auth/presentation/pages/change_password/change_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/first_step_screen/forget_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/forget_password/second_step_screen/new_password_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_in/sign_in_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:ppidunia/features/comingsoon/presentation/pages/comingsoon_screen_model.dart';
import 'package:ppidunia/features/onboarding/presentation/pages/onboarding_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/first_step_screen/sign_up_screen_model.dart';
import 'package:ppidunia/features/auth/presentation/pages/sign_up/second_step_screen/study_abroad_status_screen_model.dart';
import 'package:ppidunia/features/splash/presentation/pages/splash_screen_model.dart';
import 'package:ppidunia/features/update/presentation/pages/update_screen_model.dart';
import 'package:ppidunia/features/dashboard/presentation/pages/dashboard_screen_model.dart';
import 'package:ppidunia/features/feed/presentation/pages/bookmarks/bookmark_screen_model.dart';
import 'package:ppidunia/features/inbox/presentation/pages/inbox_screen_model.dart';
import 'package:ppidunia/features/sos/presentation/pages/sos_screen_model.dart';

import 'container.dart' as c;

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => c.getIt<BannerProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocalizationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FirebaseProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SplashScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ComingSoonScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<UpdateScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<OnboardingScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SignInScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SignUpScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ForgetPasswordScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NewPasswordScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ChangePasswordScreenModel>()),
  ChangeNotifierProvider(
      create: (_) => c.getIt<StudyAbroadStatusScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<OtpScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<CommentScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<DashboardScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<CreatePostModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<BookmarkScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ProfileProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<InboxScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SosScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<TermsOfUseScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<PrivacyPolicyScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NotificationNotifier>()),
  ChangeNotifierProvider(create: (_) => c.getIt<StorageNotifier>()),
  ChangeNotifierProvider(create: (_) => c.getIt<CommentDetailModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<EventScreenModel>()),
  ChangeNotifierProvider(create: (_) => c.getIt<EventDetailScreenModel>()),
  Provider.value(value: const <String, dynamic>{})
];
