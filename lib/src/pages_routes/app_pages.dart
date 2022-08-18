import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:quitanda_virtual/src/pages/auth/sign_in_screen.dart';
import 'package:quitanda_virtual/src/pages/auth/sign_up_screen.dart';
import 'package:quitanda_virtual/src/pages/base/base_screen.dart';
import 'package:quitanda_virtual/src/pages/splash/splash_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      page: () => const SplashScreen(),
      name: PagesRoutes.splashRoute,
    ),
    GetPage(
      page: () => SignInScreen(),
      name: PagesRoutes.signInRoute,
    ),
    GetPage(
      page: () => SignUpScreen(),
      name: PagesRoutes.signUpRoute,
    ),
    GetPage(
      page: () => const BaseScreen(),
      name: PagesRoutes.baseRoute,
    ),
  ];
}

abstract class PagesRoutes {
  static const String signInRoute = '/sign-in';
  static const String splashRoute = '/splash';
  static const String signUpRoute = '/sign-up';
  static const String baseRoute = '/';
}
