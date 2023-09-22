import 'package:flutter/foundation.dart';

import '../../services/services.dart';
import 'splash_state.dart';

class SplashController extends ChangeNotifier {
  SplashController({
    required this.secureStorageService,
  });

  final SecureStorageService secureStorageService;

  SplashState _state = SplashStateInitial();

  SplashState get state => _state;

  void _changeState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> isUserLogged() async {
    final result = await secureStorageService.readOne(key: "CURRENT_USER");
    if (result != null) {
      _changeState(AuthenticatedUser());
    } else {
      _changeState(UnauthenticatedUser());
    }
  }
}
