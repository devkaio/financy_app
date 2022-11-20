import 'package:financy_app/common/constants/routes.dart';
import 'package:financy_app/features/onboarding/onboarding_page.dart';
import 'package:financy_app/features/sign_in/sign_in_page.dart';
import 'package:financy_app/features/sign_up/sign_up_page.dart';
import 'package:financy_app/features/splash/splash_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: defaultTheme,
      initialRoute: NamedRoute.splash,
      routes: {
        NamedRoute.initial: (context) => const OnboardingPage(),
        NamedRoute.splash: (context) => const SplashPage(),
        NamedRoute.signUp: (context) => const SignUpPage(),
        NamedRoute.signIn: (context) => const SignInPage(),
      },
    );
  }
}
