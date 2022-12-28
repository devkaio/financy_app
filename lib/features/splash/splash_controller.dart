import 'package:flutter/foundation.dart';

import '../../services/secure_storage.dart';
import 'splash_state.dart';

class SplashController extends ChangeNotifier {
  final SecureStorage _secureStorage;

  SplashController(this._secureStorage);

  SplashState _state = SplashStateInitial();

  SplashState get state => _state;

  void _changeState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> isUserLogged() async {
    final result = await _secureStorage.readOne(key: "CURRENT_USER");
    if (result != null) {
      _changeState(AuthenticatedUser());
    } else {
      _changeState(UnauthenticatedUser());
    }
  }
}
