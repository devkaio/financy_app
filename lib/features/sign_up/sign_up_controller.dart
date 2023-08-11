import 'package:flutter/foundation.dart';

import '../../services/services.dart';
import 'sign_up_state.dart';

class SignUpController extends ChangeNotifier {
  SignUpController({
    required AuthService authService,
    required SecureStorageService secureStorageService,
  })  : _secureStorageService = secureStorageService,
        _authService = authService;

  final AuthService _authService;
  final SecureStorageService _secureStorageService;

  SignUpState _state = SignUpStateInitial();

  SignUpState get state => _state;

  void _changeState(SignUpState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _changeState(SignUpStateLoading());

    final result = await _authService.signUp(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (error) => _changeState(SignUpStateError(error.message)),
      (data) async {
        await _secureStorageService.write(
          key: "CURRENT_USER",
          value: data.toJson(),
        );

        _changeState(SignUpStateSuccess());
      },
    );
  }
}
