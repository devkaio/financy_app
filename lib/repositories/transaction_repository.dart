import 'package:graphql_flutter/graphql_flutter.dart';

import '../common/constants/mutations.dart';
import '../common/constants/queries.dart';
import '../common/models/balances_model.dart';
import '../common/models/transaction_model.dart';
import '../data/data_result.dart';
import '../data/exceptions.dart';
import '../services/api_service.dart';

abstract class TransactionRepository {
  Future<DataResult<bool>> addTransaction(
    TransactionModel transactionModel,
    String userId,
  );

  Future<DataResult<bool>> updateTransaction(TransactionModel transactionModel);

  Future<DataResult<List<TransactionModel>>> getTransactions({
    int? limit,
    int? offset,
  });

  Future<DataResult<bool>> deleteTransaction(String id);

  Future<DataResult<BalancesModel>> getBalances();
}

class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({
    required this.graphqlService,
  });

  final ApiService<GraphQLClient, QueryResult> graphqlService;
  @override
  Future<DataResult<bool>> addTransaction(
    TransactionModel transaction,
    String userId,
  ) async {
    try {
      final response = await graphqlService.create(
        path: Mutations.mAddNewTransaction,
        params: {
          ...transaction.toMap(),
          "user_id": userId,
        },
      );

      return DataResult.success(response.data != null);
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<DataResult<List<TransactionModel>>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await graphqlService.read(
        path: Queries.qGetTrasactions,
        params: {
          'limit': limit,
          'offset': offset,
        },
      );

      final parsedData = List.from(response.data?['transaction'] ?? []);

      final transactions =
          parsedData.map((e) => TransactionModel.fromMap(e)).toList();

      return DataResult.success(transactions);
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<DataResult<BalancesModel>> getBalances() async {
    try {
      final response = await graphqlService.read(path: Queries.qGetBalances);

      final balances = BalancesModel.fromMap(response.data ?? {});

      return DataResult.success(balances);
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<DataResult<bool>> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await graphqlService.update(
        path: Mutations.mUpdateTransaction,
        params: transaction.toMap(),
      );
      return DataResult.success(response.data != null);
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<DataResult<bool>> deleteTransaction(String id) async {
    try {
      final response = await graphqlService.delete(
        path: Mutations.mDeleteTransaction,
        params: {'id': id},
      );

      return DataResult.success(response.data != null);
    } catch (e) {
      return _handleException(e);
    }
  }

  DataResult<T> _handleException<T>(dynamic e) {
    if (e is OperationException && e.linkException != null) {
      return DataResult.failure(
        const ConnectionException(code: 'connection-error'),
      );
    }

    if (e is OperationException && e.graphqlErrors.isNotEmpty) {
      return DataResult.failure(
        APIException(
          code: 0,
          textCode: e.graphqlErrors.first.extensions?['code'],
        ),
      );
    }

    if (e is AuthException) {
      return DataResult.failure(
        AuthException(code: e.code),
      );
    }

    return DataResult.failure(const GeneralException());
  }
}
