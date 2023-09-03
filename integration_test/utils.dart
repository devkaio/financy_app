import 'package:financy_app/app.dart';
import 'package:financy_app/firebase_options.dart';
import 'package:financy_app/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class Utils {
  const Utils();

  /// Setup dependencies and returns [App] widget.
  /// Usually called in [setUp] method within main test.
  Future<Widget> createAppUnderTest() async {
    await locator.reset();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    setupDependencies();

    await locator.allReady();

    return const App();
  }
}
