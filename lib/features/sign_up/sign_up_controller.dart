import 'package:flutter/foundation.dart';

import '../../services/auth_service.dart';
import '../../services/graphql_service.dart';
import '../../services/secure_storage.dart';
import 'sign_up_state.dart';

class SignUpController extends ChangeNotifier {
  SignUpController({
    required this.authService,
    required this.secureStorageService,
    required this.graphQLService,
  });

  final AuthService authService;
  final SecureStorageService secureStorageService;
  final GraphQLService graphQLService;

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

    try {
      final user = await authService.signUp(
        name: name,
        email: email,
        password: password,
      );
      if (user.id != null) {
        await secureStorageService.write(
          key: "CURRENT_USER",
          value: user.toJson(),
        );

        await graphQLService.init();

        _changeState(SignUpStateSuccess());
      } else {
        throw Exception();
      }
    } catch (e) {
      _changeState(SignUpStateError(e.toString()));
    }
  }
}
