import 'package:firebase_auth/firebase_auth.dart';

import '../../common/data/data.dart';
import '../../common/models/models.dart';
import 'user_data_service.dart';

class UserDataServiceImpl implements UserDataService {
  UserDataServiceImpl({required FirebaseAuth firebaseAuth})
      : _auth = firebaseAuth;

  final FirebaseAuth _auth;

  @override
  Future<DataResult<UserModel>> getUserData() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        return Future.value(DataResult.success(
          UserModel(
            email: user.email!,
            name: user.displayName!,
            id: user.uid,
          ),
        ));
      }

      throw const UserDataException();
    } catch (e) {
      return Future.value(DataResult.failure(const UserDataException()));
    }
  }
}
