import 'package:financy_app/common/constants/constants.dart';
import 'package:financy_app/features/onboarding/onboarding_page.dart';
import 'package:financy_app/features/sign_in/sign_in_page.dart';
import 'package:financy_app/features/sign_up/sign_up_page.dart';
import 'package:financy_app/features/splash/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'robot_extension.dart';

class OnboardingRobot {
  const OnboardingRobot(this.tester);

  final WidgetTester tester;

  Future<void> processOnboarding() async {
    final splashPage = find.byType(SplashPage);
    await tester.waitUntilFind(splashPage);
    expect(splashPage, findsOneWidget);

    final onboardingPage = find.byType(OnboardingPage);
    await tester.waitUntilFind(onboardingPage);
    expect(onboardingPage, findsOneWidget);

    final getStartedButton = find.byKey(Keys.onboardingGetStartedButton);
    expect(getStartedButton, findsOneWidget);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    final signUpPage = find.byType(SignUpPage);
    await tester.waitUntilFind(signUpPage);
    expect(signUpPage, findsOneWidget);

    final signUpListView = find.byKey(Keys.signUpListView);

    final alreadyHaveAccountButton =
        find.byKey(Keys.signUpAlreadyHaveAccountButton);

    await tester.dragUntilFind(
      target: alreadyHaveAccountButton,
      scrollable: signUpListView,
    );

    expect(alreadyHaveAccountButton, findsOneWidget);
    await tester.tap(alreadyHaveAccountButton);

    await tester.pumpAndSettle();

    final signInPage = find.byType(SignInPage);
    await tester.waitUntilFind(signInPage);
    expect(signInPage, findsOneWidget);
  }
}
