abstract class ForgotPasswordState {}

class ForgotPasswordStateInitial extends ForgotPasswordState {}

class ForgotPasswordStateLoading extends ForgotPasswordState {}

class ForgotPasswordStateSuccess extends ForgotPasswordState {}

class ForgotPasswordStateError extends ForgotPasswordState {
  final String message;

  ForgotPasswordStateError(this.message);
}
