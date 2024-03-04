import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robots/robot_extension.dart';
import 'utils.dart';

void main() {
  //Necessary to run integration tests
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //The app under test
  late Widget aut;
  const String email = 'user@tester.com';
  const String password = '123456Abc';

  setUp(() async {
    aut = await const Utils().createAppUnderTest();
  });

  testWidgets('Onboarding Test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await tester.onboarding.processOnboarding();
  });

  testWidgets('Failed Login Test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await tester.signInRobot.signInWithEmailAndPassword(
      email: email,
      password: password,
      shouldFail: true,
    );
  });

  testWidgets('Successful Login Test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await tester.signInRobot.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  });

  testWidgets('Logout test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await tester.signOutRobot.signOut();
  });

  testWidgets('Successful Forgot Password Test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await tester.forgotPasswordRobot.forgotPassword(email: email);
  });

  testWidgets('Failed Forgot Password Test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await tester.forgotPasswordRobot.forgotPassword(
      email: email,
      shouldFail: true,
    );
  });
}
