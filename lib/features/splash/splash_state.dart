abstract class SplashState {}

class SplashStateInitial extends SplashState {}

class AuthenticatedUser extends SplashState {
  final String message;
  final bool isReady;

  AuthenticatedUser({
    this.message = '',
    this.isReady = false,
  });
}

class UnauthenticatedUser extends SplashState {}
