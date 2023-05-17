import 'package:financy_app/common/constants/mutations/delete_transaction.dart';
import 'package:financy_app/data/data_result.dart';
import 'package:financy_app/data/exceptions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../common/constants/mutations/add_new_transaction.dart';
import '../common/constants/mutations/update_transaction.dart';
import '../common/constants/queries/get_balances.dart';
import '../common/constants/queries/get_transactions.dart';
import '../common/models/balances_model.dart';
import '../common/models/transaction_model.dart';
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
        path: mAddNewTransaction,
        params: {
          ...transaction.toMap(),
          "user_id": userId,
        },
      );

      return DataResult.success(response.data != null);
    } on ServerException {
      return DataResult.failure(
          const ConnectionException(code: 'connection-error'));
    } on GraphQLError catch (e) {
      return DataResult.failure(
        APIException(
          code: 0,
          textCode: e.extensions?['code'],
        ),
      );
    } catch (e) {
      return DataResult.failure(const GeneralException());
    }
  }

  @override
  Future<DataResult<List<TransactionModel>>> getTransactions({
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await graphqlService.read(
        path: qGetTrasactions,
        params: {
          'limit': limit,
          'offset': offset,
        },
      );

      final parsedData = List.from(response.data?['transaction'] ?? []);

      final transactions =
          parsedData.map((e) => TransactionModel.fromMap(e)).toList();

      return DataResult.success(transactions);
    } on ServerException {
      return DataResult.failure(
          const ConnectionException(code: 'connection-error'));
    } on GraphQLError catch (e) {
      return DataResult.failure(
        APIException(
          code: 0,
          textCode: e.extensions?['code'],
        ),
      );
    } on AuthException catch (e) {
      return DataResult.failure(AuthException(code: e.code));
    } catch (e) {
      return DataResult.failure(const GeneralException());
    }
  }

  @override
  Future<DataResult<BalancesModel>> getBalances() async {
    try {
      final response = await graphqlService.read(path: qGetBalances);

      final balances = BalancesModel.fromMap(response.data ?? {});

      return DataResult.success(balances);
    } on ServerException {
      return DataResult.failure(
          const ConnectionException(code: 'connection-error'));
    } on GraphQLError catch (e) {
      return DataResult.failure(
        APIException(
          code: 0,
          textCode: e.extensions?['code'],
        ),
      );
    } on AuthException catch (e) {
      return DataResult.failure(AuthException(code: e.code));
    } catch (e) {
      return DataResult.failure(const GeneralException());
    }
  }

  @override
  Future<DataResult<bool>> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await graphqlService.update(
        path: mUpdateTransaction,
        params: transaction.toMap(),
      );
      return DataResult.success(response.data != null);
    } on ServerException {
      return DataResult.failure(
          const ConnectionException(code: 'connection-error'));
    } on GraphQLError catch (e) {
      return DataResult.failure(
        APIException(
          code: 0,
          textCode: e.extensions?['code'],
        ),
      );
    } catch (e) {
      return DataResult.failure(const GeneralException());
    }
  }

  @override
  Future<DataResult<bool>> deleteTransaction(String id) async {
    try {
      final response = await graphqlService.delete(
        path: mDeleteTransaction,
        params: {'id': id},
      );

      return DataResult.success(response.data != null);
    } on ServerException {
      return DataResult.failure(
          const ConnectionException(code: 'connection-error'));
    } on GraphQLError catch (e) {
      return DataResult.failure(
        APIException(
          code: 0,
          textCode: e.extensions?['code'],
        ),
      );
    } catch (e) {
      return DataResult.failure(const GeneralException());
    }
  }
}
