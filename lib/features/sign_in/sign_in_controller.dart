import 'package:flutter/foundation.dart';

import '../../services/auth_service.dart';
import '../../services/secure_storage.dart';
import 'sign_in_state.dart';

class SignInController extends ChangeNotifier {
  final AuthService _service;
  final SecureStorage _secureStorage;

  SignInController(this._service, this._secureStorage);

  SignInState _state = SignInStateInitial();

  SignInState get state => _state;

  void _changeState(SignInState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _changeState(SignInStateLoading());

    try {
      final user = await _service.signIn(
        email: email,
        password: password,
      );

      if (user.id != null) {
        await _secureStorage.write(key: "CURRENT_USER", value: user.toJson());

        _changeState(SignInStateSuccess());
      } else {
        throw Exception();
      }
    } catch (e) {
      _changeState(SignInStateError(e.toString()));
    }
  }
}
