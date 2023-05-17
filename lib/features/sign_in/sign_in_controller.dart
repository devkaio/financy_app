import 'package:flutter/foundation.dart';

import '../../services/auth_service.dart';
import '../../services/secure_storage.dart';
import 'sign_in_state.dart';

class SignInController extends ChangeNotifier {
  SignInController({
    required this.authService,
    required this.secureStorageService,
  });

  final AuthService authService;
  final SecureStorageService secureStorageService;

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

    final result = await authService.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (error) => _changeState(SignInStateError(error.message)),
      (data) async {
        await secureStorageService.write(
          key: "CURRENT_USER",
          value: data.toJson(),
        );

        _changeState(SignInStateSuccess());
      },
    );
  }
}
