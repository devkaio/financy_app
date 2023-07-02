abstract class SplashState {}

class SplashStateInitial extends SplashState {}

class AuthenticatedUser extends SplashState {
  AuthenticatedUser();
}

class UnauthenticatedUser extends SplashState {}
