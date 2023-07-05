import 'package:firebase_auth/firebase_auth.dart';

import '../../common/data/data.dart';
import '../../common/models/models.dart';
import 'user_data_service.dart';

class UserDataServiceImpl implements UserDataService {
  UserDataServiceImpl(this._auth);

  final FirebaseAuth _auth;

  @override
  DataResult<UserModel> getUserData() {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        return DataResult.success(UserModel(
          email: user.email!,
          name: user.displayName!,
          id: user.uid,
        ));
      }

      throw const UserDataException();
    } catch (e) {
      return DataResult.failure(const UserDataException());
    }
  }
}
