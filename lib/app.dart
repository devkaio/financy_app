import 'package:flutter/material.dart';

import 'common/constants/constants.dart';
import 'common/models/models.dart';
import 'common/themes/default_theme.dart';
import 'features/forgot_password/check_your_email_page.dart';
import 'features/forgot_password/forgot_password_page.dart';
import 'features/home/home.dart';
import 'features/onboarding/onboarding.dart';
import 'features/profile/profile.dart';
import 'features/sign_in/sign_in.dart';
import 'features/sign_up/sign_up.dart';
import 'features/splash/splash.dart';
import 'features/stats/stats.dart';
import 'features/transactions/transactions.dart';
import 'features/wallet/wallet.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme().defaultTheme,
      initialRoute: NamedRoute.splash,
      routes: {
        NamedRoute.initial: (context) => const OnboardingPage(),
        NamedRoute.splash: (context) => const SplashPage(),
        NamedRoute.signUp: (context) => const SignUpPage(),
        NamedRoute.signIn: (context) => const SignInPage(),
        NamedRoute.home: (context) => const HomePageView(),
        NamedRoute.stats: (context) => const StatsPage(),
        NamedRoute.wallet: (context) => const WalletPage(),
        NamedRoute.profile: (context) => const ProfilePage(),
        NamedRoute.transaction: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return TransactionPage(
            transaction: args != null ? args as TransactionModel : null,
          );
        },
        NamedRoute.forgotPassword: (context) => const ForgotPasswordPage(),
        NamedRoute.checkYourEmail: (context) => const CheckYourEmailPage(),
      },
    );
  }
}
