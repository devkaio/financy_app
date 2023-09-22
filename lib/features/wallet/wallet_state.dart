abstract class WalletState {}

class WalletStateInitial extends WalletState {}

class WalletStateLoading extends WalletState {}

class WalletStateSuccess extends WalletState {}

class WalletStateError extends WalletState {
  WalletStateError({required this.message});

  final String message;
}
