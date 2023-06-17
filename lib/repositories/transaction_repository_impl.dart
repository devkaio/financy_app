import 'dart:async';

import '../common/data/data.dart';
import '../common/models/models.dart';
import '../services/services.dart';
import 'transaction_repository.dart';

/// {@macro transaction_repository}
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({
    required this.databaseService,
    required this.syncService,
  });

  final DataService<Map<String, dynamic>> databaseService;
  final SyncService syncService;

  @override
  Future<DataResult<bool>> addTransaction({
    required TransactionModel transaction,
    required String userId,
  }) async {
    try {
      final newTransaction = transaction
          .copyWith(userId: userId, syncStatus: SyncStatus.create)
          .toDatabase();

      await updateBalance(TransactionModel.fromMap(newTransaction));

      await syncService.saveLocalChanges(
        path: TransactionRepository.transactionsPath,
        params: newTransaction,
      );

      return DataResult.success(true);
    } on Failure catch (e) {
      return DataResult.failure(e);
    }
  }

  @override
  Future<DataResult<List<TransactionModel>>> getTransactions({
    int? limit,
    int? offset,
    bool latest = false,
  }) async {
    final params = {
      'limit': limit,
      'offset': offset,
      'skip_status': SyncStatus.delete.name,
    };

    try {
      final cachedTransactionsResponse = await databaseService.read(
        path: TransactionRepository.transactionsPath,
        params: latest
            ? {
                ...params,
                'order_by': 'date desc',
              }
            : {
                ...params,
                'order_by': 'date asc',
              },
      );

      final parsedcachedTransactions =
          List.from(cachedTransactionsResponse['data']);

      final cachedTransactions = parsedcachedTransactions
          .map((e) => TransactionModel.fromMap(e))
          .toList();

      // return DataResult.failure(const GeneralException());

      return DataResult.success(cachedTransactions);
    } on Failure catch (e) {
      return DataResult.failure(e);
    }
  }

  @override
  Future<DataResult<BalancesModel>> getBalances() async {
    try {
      final balanceResponse =
          await databaseService.read(path: TransactionRepository.balancesPath);
      BalancesModel cachedBalances =
          BalancesModel.fromMap((balanceResponse['data'] as List).first);

      return DataResult.success(cachedBalances);
    } on Failure catch (e) {
      return DataResult.failure(e);
    }
  }

  @override
  Future<DataResult<bool>> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      await updateBalance(transaction);

      await syncService.saveLocalChanges(
        path: TransactionRepository.transactionsPath,
        params:
            transaction.copyWith(syncStatus: SyncStatus.update).toDatabase(),
      );

      return DataResult.success(true);
    } on Failure catch (e) {
      return DataResult.failure(e);
    }
  }

  @override
  Future<DataResult<bool>> deleteTransaction(
      TransactionModel transaction) async {
    try {
      await updateBalance(transaction);

      final deleteTransactionResponse = await databaseService.delete(
        path: TransactionRepository.transactionsPath,
        params: {'id': transaction.id},
      );

      await syncService.saveLocalChanges(
        path: TransactionRepository.transactionsPath,
        params:
            transaction.copyWith(syncStatus: SyncStatus.delete).toDatabase(),
      );

      return DataResult.success(deleteTransactionResponse.isNotEmpty);
    } on Failure catch (e) {
      return DataResult.failure(e);
    }
  }

  @override
  Future<void> updateBalance(newTransaction) async {
    final transactionMap = await databaseService.read(
      path: TransactionRepository.transactionsPath,
      params: {'id': newTransaction.id},
    );

    final transactionExists = (transactionMap['data'] as List).isNotEmpty;

    final oldTransaction = transactionExists
        ? TransactionModel.fromMap((transactionMap['data'] as List).first)
        : null;

    final balanceMap =
        await databaseService.read(path: TransactionRepository.balancesPath);

    final current = BalancesModel.fromMap((balanceMap['data'] as List).first);

    double newTotalBalance = current.totalBalance;

    double newTotalIncome = current.totalIncome;

    double newTotalOutcome = current.totalOutcome;

    if (transactionExists) {
      final differentValues = oldTransaction!.value != newTransaction.value;

      double updatedValue = differentValues
          ? _computeNewValue(
              oldTransaction.value,
              newTransaction.value,
            )
          : oldTransaction.value;

      if (differentValues) {
        newTotalBalance -= oldTransaction.value;
        newTotalBalance += updatedValue;

        if (updatedValue >= 0) {
          newTotalIncome -= oldTransaction.value;
          newTotalIncome += updatedValue;
        } else {
          newTotalOutcome -= oldTransaction.value;
          newTotalOutcome += updatedValue;
        }

        final updatedBalance = current
            .copyWith(
              totalBalance: newTotalBalance,
              totalIncome: newTotalIncome,
              totalOutcome: newTotalOutcome,
            )
            .toMap();

        final updateBalanceResponse = await databaseService.update(
          path: TransactionRepository.balancesPath,
          params: updatedBalance,
        );

        if (!(updateBalanceResponse['data'] as bool)) {
          throw const CacheException(code: 'write');
        }

        return;
      }

      newTotalBalance -= updatedValue;

      if (updatedValue >= 0) {
        newTotalIncome -= updatedValue;
      } else {
        newTotalOutcome -= updatedValue;
      }
    } else {
      newTotalBalance += newTransaction.value;

      if (newTransaction.value >= 0) {
        newTotalIncome += newTransaction.value;
      } else {
        newTotalOutcome += newTransaction.value;
      }
    }

    final updatedBalance = current
        .copyWith(
          totalBalance: newTotalBalance,
          totalIncome: newTotalIncome,
          totalOutcome: newTotalOutcome,
        )
        .toMap();

    final updateBalanceResponse = await databaseService.update(
      path: TransactionRepository.balancesPath,
      params: updatedBalance,
    );

    if (!(updateBalanceResponse['data'] as bool)) {
      throw const CacheException(code: 'write');
    }
  }

  double _computeNewValue(
    double oldValue,
    double newValue,
  ) =>
      (oldValue + newValue) - oldValue;
}
