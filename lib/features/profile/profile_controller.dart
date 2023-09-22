import 'package:flutter/foundation.dart';

import '../../common/models/models.dart';
import '../../services/services.dart';
import 'profile_state.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({required UserDataService userDataService})
      : _userDataService = userDataService;

  final UserDataService _userDataService;

  ProfileState _state = ProfileStateInitial();

  ProfileState get state => _state;

  UserModel get userData => _userDataService.userData;

  bool get canSave => enabledButton && state is! ProfileStateLoading;

  void _changeState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  bool _reauthRequired = false;
  bool get reauthRequired => _reauthRequired;

  bool _showUpdatedNameMessage = false;
  bool get showNameUpdateMessage =>
      _showUpdatedNameMessage && state is ProfileStateSuccess;

  bool _showUpdatedPasswordMessage = false;
  bool get showPasswordUpdateMessage =>
      _showUpdatedPasswordMessage && state is ProfileStateSuccess;

  bool _showChangeName = false;
  bool get showChangeName => _showChangeName;
  void onChangeNameTapped() {
    _showChangeName = !showChangeName;
    _changeState(ProfileStateInitial());
  }

  bool _showChangePassword = false;
  bool get showChangePassword => _showChangePassword;
  void onChangePasswordTapped() {
    _showChangePassword = !showChangePassword;
    _changeState(ProfileStateInitial());
  }

  bool _enabledButton = false;
  bool get enabledButton => _enabledButton;
  void toggleButtonTap(bool value) {
    _enabledButton = value;
    _changeState(ProfileStateInitial());
  }

  Future<void> getUserData() async {
    final result = await _userDataService.getUserData();

    result.fold(
      (error) => _changeState(ProfileStateError(message: error.message)),
      (data) => _changeState(ProfileStateSuccess(user: data)),
    );
  }

  Future<void> updateUserName(String newUserName) async {
    _changeState(ProfileStateLoading());

    final result = await _userDataService.updateUserName(newUserName);
    result.fold(
      (error) => _changeState(ProfileStateError(message: error.message)),
      (_) {
        _showUpdatedNameMessage = true;
        _showUpdatedPasswordMessage = false;
        onChangeNameTapped();
        toggleButtonTap(false);
        _changeState(ProfileStateSuccess());
      },
    );
  }

  Future<void> updateUserPassword(String newPassword) async {
    _changeState(ProfileStateLoading());
    final result = await _userDataService.updatePassword(newPassword);
    result.fold(
      (error) {
        _reauthRequired = true;
        _changeState(ProfileStateError(message: error.message));
      },
      (_) {
        _showUpdatedPasswordMessage = true;
        _showUpdatedNameMessage = false;
        onChangePasswordTapped();
        toggleButtonTap(false);
        _changeState(ProfileStateSuccess());
      },
    );
  }

  Future<void> deleteAccount() async {
    _changeState(ProfileStateLoading());
    final result = await _userDataService.deleteAccount();
    result.fold(
      (error) => _changeState(ProfileStateError(message: error.message)),
      (_) => _changeState(ProfileStateSuccess()),
    );
  }
}
