import 'package:financy_app/common/constants/constants.dart';
import 'package:financy_app/features/home/home_page_view.dart';
import 'package:financy_app/features/onboarding/onboarding_page.dart';
import 'package:financy_app/features/profile/profile_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'robot_extension.dart';

class SignOutRobot {
  const SignOutRobot(this.tester);

  final WidgetTester tester;

  Future<void> signOut() async {
    final homePage = find.byType(HomePageView);
    await tester.waitUntilFind(homePage);
    expect(homePage, findsOneWidget);

    final profileButton = find.byKey(Keys.profilePageBottomAppBarItem);
    await tester.tap(profileButton);

    final profilePage = find.byType(ProfilePage);
    await tester.waitUntilFind(profilePage);
    expect(profilePage, findsOneWidget);

    final logoutButton = find.byKey(Keys.profilePagelogoutButton);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);

    final signInPage = find.byType(OnboardingPage);
    await tester.waitUntilFind(signInPage);
    expect(signInPage, findsOneWidget);
  }
}
