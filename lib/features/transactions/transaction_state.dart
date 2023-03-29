abstract class TransactionState {}

class TransactionStateInitial extends TransactionState {}

class TransactionStateLoading extends TransactionState {}

class TransactionStateSuccess extends TransactionState {}

class TransactionStateError extends TransactionState {}
