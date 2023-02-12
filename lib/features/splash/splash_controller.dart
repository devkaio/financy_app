import 'package:flutter/foundation.dart';

import '../../services/graphql_service.dart';
import '../../services/secure_storage.dart';
import 'splash_state.dart';

class SplashController extends ChangeNotifier {
  final SecureStorage secureStorage;
  final GraphQLService graphQLService;

  SplashController({
    required this.secureStorage,
    required this.graphQLService,
  });

  SplashState _state = SplashStateInitial();

  SplashState get state => _state;

  void _changeState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> isUserLogged() async {
    final result = await secureStorage.readOne(key: "CURRENT_USER");
    if (result != null) {
      await graphQLService.init();
      _changeState(AuthenticatedUser());
    } else {
      _changeState(UnauthenticatedUser());
    }
  }
}
