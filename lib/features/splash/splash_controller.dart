import 'package:flutter/foundation.dart';

import '../../services/graphql_service.dart';
import '../../services/secure_storage.dart';
import 'splash_state.dart';

class SplashController extends ChangeNotifier {
  SplashController({
    required this.secureStorageService,
    required this.graphQLService,
  });

  final SecureStorageService secureStorageService;
  final GraphQLService graphQLService;

  SplashState _state = SplashStateInitial();

  SplashState get state => _state;

  void _changeState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> isUserLogged() async {
    final result = await secureStorageService.readOne(key: "CURRENT_USER");
    if (result != null) {
      await graphQLService.init();
      _changeState(AuthenticatedUser());
    } else {
      _changeState(UnauthenticatedUser());
    }
  }
}
