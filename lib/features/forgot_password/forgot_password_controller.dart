import 'package:financy_app/services/auth_service/auth_service.dart';
import 'package:flutter/foundation.dart';

import 'forgot_password_state.dart';

class ForgotPasswordController extends ChangeNotifier {
  ForgotPasswordController({
    required AuthService authService,
  }) : _authService = authService;

  final AuthService _authService;

  ForgotPasswordState _state = ForgotPasswordStateInitial();

  ForgotPasswordState get state => _state;

  void _changeState(ForgotPasswordState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    _changeState(ForgotPasswordStateLoading());
    final result = await _authService.forgotPassword(email);
    result.fold(
      (error) => _changeState(ForgotPasswordStateError(error.message)),
      (data) => _changeState(ForgotPasswordStateSuccess()),
    );
  }
}
