import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robots/robots.dart';
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

    await const OnbordingRobot().call(tester);
  });

  testWidgets('Failed Login Test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await const SignInRobot(
      email: email,
      password: password,
    ).call(tester, shouldFail: true);
  });

  testWidgets('Successful Login Test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await const SignInRobot(
      email: email,
      password: password,
    ).call(tester);
  });

  testWidgets('Logout test', (WidgetTester tester) async {
    await tester.pumpWidget(aut);

    await const LogoutRobot(
      email: 'user@tester.com',
      password: '123456Abc',
    ).call(tester);
  });
}
