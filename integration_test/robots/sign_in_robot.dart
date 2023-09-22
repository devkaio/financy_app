import 'package:financy_app/common/constants/keys.dart';
import 'package:financy_app/features/home/home_page_view.dart';
import 'package:financy_app/features/onboarding/onboarding_page.dart';
import 'package:financy_app/features/sign_in/sign_in_page.dart';
import 'package:financy_app/features/splash/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'robot_extension.dart';

class SignInRobot {
  const SignInRobot(this.tester);

  final WidgetTester tester;

  ///Remember to set [shouldFail] to `true` when login must fail.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool shouldFail = false,
  }) async {
    final splashPage = find.byType(SplashPage);
    await tester.waitUntilFind(splashPage);
    expect(splashPage, findsOneWidget);

    final onboardingPage = find.byType(OnboardingPage);
    await tester.waitUntilFind(onboardingPage);
    expect(onboardingPage, findsOneWidget);

    final alreadyHaveAccountButton =
        find.byKey(Keys.onboardingAlreadyHaveAccountButton);

    expect(alreadyHaveAccountButton, findsOneWidget);
    await tester.tap(alreadyHaveAccountButton);

    final signInPage = find.byType(SignInPage);
    await tester.waitUntilFind(signInPage);
    expect(signInPage, findsOneWidget);

    final signInListView = find.byKey(Keys.signInListView);

    final emailField = find.byKey(Keys.signInEmailField);
    await tester.waitUntilFind(emailField);
    expect(emailField, findsOneWidget);

    if (shouldFail) {
      await tester.enterText(emailField, 'wrong@email.com');
    } else {
      await tester.enterText(emailField, email);
    }

    final passwordField = find.byKey(Keys.signInPasswordField);

    await tester.dragUntilFind(
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

    await tester.dragUntilFind(
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
      await tester.waitUntilFind(homePage);
      expect(homePage, findsOneWidget);
    }
  }
}
