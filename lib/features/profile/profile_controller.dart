import 'package:flutter/foundation.dart';

import '../../services/services.dart';
import 'profile_state.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({required this.userDataService});

  final UserDataService userDataService;

  ProfileState _state = ProfileStateInitial();

  ProfileState get state => _state;

  void _changeState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getUserData() async {
    final result = await userDataService.getUserData();

    result.fold(
      (error) => _changeState(ProfileStateError(message: error.message)),
      (data) => _changeState(ProfileStateSuccess(user: data)),
    );
  }
}
