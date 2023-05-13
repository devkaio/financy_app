abstract class TransactionListViewState {}

class TransactionListViewStateInitial extends TransactionListViewState {}

class TransactionListViewStateLoading extends TransactionListViewState {}

class TransactionListViewStateSuccess extends TransactionListViewState {}

class TransactionListViewStateError extends TransactionListViewState {
  TransactionListViewStateError(this.message);

  final String message;
}
