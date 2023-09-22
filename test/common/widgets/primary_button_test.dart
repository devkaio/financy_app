import 'dart:developer';

import 'package:financy_app/common/widgets/primary_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Should check if button text is correctly placed',
    (WidgetTester tester) async {
      Widget buildFrame() {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: PrimaryButton(
            onPressed: () => log('pressed'),
            text: 'button',
          ),
        );
      }

      await tester.pumpWidget(buildFrame());
      expect(find.text('button'), findsOneWidget);
    },
  );
  testWidgets(
    'Should check if onPressed callback is called when non-null',
    (WidgetTester tester) async {
      bool wasPressed;
      Finder primaryButton;

      Widget buildFrame({VoidCallback? onPressed}) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: PrimaryButton(
            onPressed: onPressed,
            text: 'button',
          ),
        );
      }

      wasPressed = false;
      await tester.pumpWidget(
        buildFrame(onPressed: () {
          wasPressed = true;
        }),
      );
      primaryButton = find.byType(PrimaryButton);
      expect(primaryButton, findsOneWidget);
      await tester.tap(primaryButton);
      expect(wasPressed, true);

      wasPressed = false;
      await tester.pumpWidget(
        buildFrame(),
      );
      primaryButton = find.byType(PrimaryButton);
      await tester.tap(primaryButton);
      expect(wasPressed, false);
    },
  );
}
