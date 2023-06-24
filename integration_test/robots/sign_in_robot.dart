import 'package:financy_app/common/constants/keys.dart';
import 'package:financy_app/features/home/home_page_view.dart';
import 'package:financy_app/features/onboarding/onboarding_page.dart';
import 'package:financy_app/features/sign_in/sign_in_page.dart';
import 'package:financy_app/features/splash/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';

class SignInRobot {
  const SignInRobot({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  ///Remember to set [shouldFail] to `true` when login must fail.
  Future<void> call(WidgetTester tester, {bool shouldFail = false}) async {
    final splashPage = find.byType(SplashPage);
    await tester.pump();
    expect(splashPage, findsOneWidget);

    final onboardingPage = find.byType(OnboardingPage);
    await tester.pumpAndSettle();
    expect(onboardingPage, findsOneWidget);

    final alreadyHaveAccountButton =
        find.byKey(Keys.onboardingAlreadyHaveAccountButton);

    expect(alreadyHaveAccountButton, findsOneWidget);
    await tester.tap(alreadyHaveAccountButton);
    await tester.pumpAndSettle();

    final signInPage = find.byType(SignInPage);
    expect(signInPage, findsOneWidget);

    final signInListView = find.byKey(Keys.signInListView);

    final emailField = find.byKey(Keys.signInEmailField);
    expect(emailField, findsOneWidget);

    if (shouldFail) {
      await tester.enterText(emailField, 'wrong@email.com');
    } else {
      await tester.enterText(emailField, email);
    }

    final passwordField = find.byKey(Keys.signInPasswordField);

    await const Utils().dragUntilVisible(
      tester,
      target: passwordField,
      scrollable: signInListView,
    );

    expect(passwordField, findsOneWidget);

    if (shouldFail) {
      await tester.enterText(passwordField, 'wrongAbc123');
    } else {
      await tester.enterText(passwordField, password);
    }

    final signInButton = find.byKey(Keys.signInButton);

    await const Utils().dragUntilVisible(
      tester,
      target: signInButton,
      scrollable: signInListView,
    );

    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    if (shouldFail) {
      final tryAgainText = find.text('Try again');
      expect(tryAgainText, findsOneWidget);
      await tester.tap(tryAgainText);
    } else {
      final homePage = find.byType(HomePageView);
      expect(homePage, findsOneWidget);
    }
  }
}
