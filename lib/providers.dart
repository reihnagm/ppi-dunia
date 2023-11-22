
import 'package:ppidunia/providers/location/location.dart';
import 'package:ppidunia/providers/profile/profile.dart';
import 'package:ppidunia/providers/banner/banner.dart';
import 'package:ppidunia/views/screens/legality/privacy_policy/privacy_policy_screen_model.dart';
import 'package:ppidunia/views/screens/legality/terms_of_use/terms_of_use_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:ppidunia/services/firebase.dart';

import 'package:ppidunia/localization/localization.dart';

import 'package:ppidunia/views/screens/auth/change_password/change_password_screen_model.dart';
import 'package:ppidunia/views/screens/auth/forget_password/first_step_screen/forget_password_screen_model.dart';
import 'package:ppidunia/views/screens/auth/forget_password/second_step_screen/new_password_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_in/sign_in_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_up/third_step_screen/otp_screen_model.dart';
import 'package:ppidunia/views/screens/comingsoon/comingsoon_screen_model.dart';
import 'package:ppidunia/views/screens/onboarding/onboarding_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_up/first_step_screen/sign_up_screen_model.dart';
import 'package:ppidunia/views/screens/auth/sign_up/second_step_screen/study_abroad_status_screen_model.dart';
import 'package:ppidunia/views/screens/splash/splash_screen_model.dart';
import 'package:ppidunia/views/screens/update/update_screen_model.dart';
import 'package:ppidunia/views/screens/dashboard/dashboard_screen_model.dart';
import 'package:ppidunia/views/screens/feed/bookmarks/bookmark_screen_model.dart';
import 'package:ppidunia/views/screens/feed/comment/comment_screen_model.dart';
import 'package:ppidunia/views/screens/feed/feed/feed_screen_model.dart';
import 'package:ppidunia/views/screens/inbox/inbox_screen_model.dart';
import 'package:ppidunia/views/screens/sos/sos_screen_model.dart';
import 'package:ppidunia/views/screens/feed/post/create_post_screen_model.dart';

import 'package:ppidunia/services/location.dart';

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
  ChangeNotifierProvider(create: (_) => c.getIt<StudyAbroadStatusScreenModel>()),
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
  StreamProvider<UserLocation>(
    initialData: UserLocation(latitude: 0.0, longitude: 0.0),
    create: (_) => LocationService().locationStream,
  ),

  Provider.value(value: const <String, dynamic>{})
];