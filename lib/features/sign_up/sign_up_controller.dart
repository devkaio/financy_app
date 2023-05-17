import 'package:flutter/foundation.dart';

import '../../services/auth_service.dart';
import '../../services/secure_storage.dart';
import 'sign_up_state.dart';

class SignUpController extends ChangeNotifier {
  SignUpController({
    required this.authService,
    required this.secureStorageService,
  });

  final AuthService authService;
  final SecureStorageService secureStorageService;

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

    final result = await authService.signUp(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (error) => _changeState(SignUpStateError(error.message)),
      (data) async {
        await secureStorageService.write(
          key: "CURRENT_USER",
          value: data.toJson(),
        );

        _changeState(SignUpStateSuccess());
      },
    );
  }
}
