import 'package:flutter/foundation.dart';

import '../../services/auth_service.dart';
import '../../services/graphql_service.dart';
import '../../services/secure_storage.dart';
import 'sign_in_state.dart';

class SignInController extends ChangeNotifier {
  final AuthService authService;
  final SecureStorage secureStorage;
  final GraphQLService graphQLService;

  SignInController({
    required this.authService,
    required this.secureStorage,
    required this.graphQLService,
  });

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
      final user = await authService.signIn(
        email: email,
        password: password,
      );

      if (user.id != null) {
        await secureStorage.write(key: "CURRENT_USER", value: user.toJson());

        await graphQLService.init();

        _changeState(SignInStateSuccess());
      } else {
        throw Exception();
      }
    } catch (e) {
      _changeState(SignInStateError(e.toString()));
    }
  }
}
