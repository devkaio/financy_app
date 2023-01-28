import '../common/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction();
  Future<List<TransactionModel>> getAllTransactions();
}

class TransactionRepositoryImpl implements TransactionRepository {
  @override
  Future<void> addTransaction() {
    // TODO: implement addTransaction
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      TransactionModel(
        title: 'Salary',
        value: 500,
        date: DateTime.now().millisecondsSinceEpoch,
      ),
      TransactionModel(
        title: 'Dinner',
        value: -50,
        date: DateTime.now()
            .subtract(const Duration(days: 7))
            .millisecondsSinceEpoch,
      ),
    ];
  }
}
