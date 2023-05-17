import 'package:cloud_functions/cloud_functions.dart';
import 'package:financy_app/data/data_result.dart';
import 'package:financy_app/data/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/models/user_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final _auth = FirebaseAuth.instance;
  final _functions = FirebaseFunctions.instance;

  @override
  Future<DataResult<UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return DataResult.success(UserModel(
          name: _auth.currentUser?.displayName,
          email: _auth.currentUser?.email,
          id: _auth.currentUser?.uid,
        ));
      }

      return DataResult.failure(const GeneralException());
    } on FirebaseAuthException catch (e) {
      return DataResult.failure(AuthException(code: e.code));
    } catch (e) {
      return DataResult.failure(const AuthException(code: 'error'));
    }
  }

  @override
  Future<DataResult<UserModel>> signUp({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      await _functions.httpsCallable('registerUser').call({
        "email": email,
        "password": password,
        "displayName": name,
      });

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return DataResult.success(
          UserModel(
            name: _auth.currentUser?.displayName,
            email: _auth.currentUser?.email,
            id: _auth.currentUser?.uid,
          ),
        );
      }

      return DataResult.failure(const GeneralException());
    } on FirebaseAuthException catch (e) {
      return DataResult.failure(AuthException(code: e.code));
    } on FirebaseFunctionsException catch (e) {
      return DataResult.failure(AuthException(code: e.code));
    } catch (e) {
      return DataResult.failure(const AuthException(code: 'error'));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataResult<String>> userToken() async {
    try {
      final token = await _auth.currentUser?.getIdToken();

      return DataResult.success(token ?? '');
    } catch (e) {
      return DataResult.success('');
    }
  }
}
