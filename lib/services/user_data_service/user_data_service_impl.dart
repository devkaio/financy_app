import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/data/data.dart';
import '../../common/models/models.dart';
import 'user_data_service.dart';

class UserDataServiceImpl implements UserDataService {
  UserDataServiceImpl(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFunctions firebaseFunctions})
      : _auth = firebaseAuth,
        _functions = firebaseFunctions;

  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  UserModel _userData = UserModel();

  @override
  Future<DataResult<UserModel>> getUserData() async {
    try {
      await Future.delayed(Duration.zero);

      final user = _auth.currentUser;

      if (user == null) {
        throw const UserDataException(code: 'not-found');
      }

      _userData = _userData.copyWith(
        email: user.email!,
        name: user.displayName!,
        id: user.uid,
      );

      return DataResult.success(_userData);
    } on FirebaseAuthException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } catch (e) {
      return DataResult.failure(const UserDataException(code: 'not-found'));
    }
  }

  @override
  UserModel get userData => _userData;

  @override
  Future<DataResult<bool>> updatePassword(String password) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw const UserDataException(code: 'not-found');
      }

      await _auth.currentUser?.updatePassword(password);

      await _auth.currentUser?.reload();

      return DataResult.success(true);
    } on FirebaseAuthException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } on UserDataException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } catch (e) {
      return DataResult.failure(
          const UserDataException(code: 'update-password'));
    }
  }

  @override
  Future<DataResult<UserModel>> updateUserName(String name) async {
    try {
      final result = await _functions.httpsCallable('updateUserName').call({
        'id': _userData.id,
        'name': name,
      });

      if (result.data['error'] != null) {
        throw const UserDataException(code: 'update-username');
      }

      await _auth.currentUser?.updateDisplayName(name);

      await _auth.currentUser?.reload();

      final user = _auth.currentUser;

      if (user == null) {
        throw const UserDataException(code: 'not-found');
      }

      _userData = _userData.copyWith(
        email: user.email!,
        name: user.displayName!,
        id: user.uid,
      );

      return DataResult.success(_userData);
    } on FirebaseAuthException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } on FirebaseFunctionsException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } on UserDataException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } catch (e) {
      return DataResult.failure(
          const UserDataException(code: 'update-username'));
    }
  }

  @override
  Future<DataResult<bool>> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();

      return DataResult.success(true);
    } on FirebaseAuthException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } on FirebaseFunctionsException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } on UserDataException catch (e) {
      return DataResult.failure(UserDataException(code: e.code));
    } catch (e) {
      return DataResult.failure(
          const UserDataException(code: 'delete-account'));
    }
  }
}
