import '../../services/services.dart';
import 'package:flutter/foundation.dart';

import 'sign_in_state.dart';

class SignInController extends ChangeNotifier {
  SignInController({
    required this.authService,
    required this.secureStorageService,
    required this.syncService,
  });

  final AuthService authService;
  final SecureStorageService secureStorageService;
  final SyncService syncService;

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

        await syncService.syncFromServer();

        _changeState(SignInStateSuccess());
      },
    );
  }
}
