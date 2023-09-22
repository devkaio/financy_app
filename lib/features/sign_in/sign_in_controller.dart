import 'package:flutter/foundation.dart';

import '../../services/services.dart';
import 'sign_in_state.dart';

class SignInController extends ChangeNotifier {
  SignInController({
    required AuthService authService,
    required SecureStorageService secureStorageService,
  })  : _secureStorageService = secureStorageService,
        _authService = authService;

  final AuthService _authService;
  final SecureStorageService _secureStorageService;

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

    final result = await _authService.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (error) => _changeState(SignInStateError(error.message)),
      (data) async {
        await _secureStorageService.write(
          key: "CURRENT_USER",
          value: data.toJson(),
        );

        result.fold(
          (error) => _changeState(SignInStateError(error.message)),
          (_) => _changeState(SignInStateSuccess()),
        );
      },
    );
  }
}
