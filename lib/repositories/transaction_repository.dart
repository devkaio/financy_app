import 'package:graphql_flutter/graphql_flutter.dart';

import '../common/constants/mutations/add_new_transaction.dart';
import '../common/constants/mutations/update_transaction.dart';
import '../common/constants/queries/get_all_transactions.dart';
import '../common/constants/queries/get_balances.dart';
import '../common/models/balances_model.dart';
import '../common/models/transaction_model.dart';
import '../locator.dart';
import '../services/graphql_service.dart';

abstract class TransactionRepository {
  Future<bool> addTransaction(
    TransactionModel transactionModel,
    String userId,
  );

  Future<bool> updateTransaction(
    TransactionModel transactionModel,
  );
  Future<List<TransactionModel>> getAllTransactions();

  Future<BalancesModel> getBalances();
}

class TransactionRepositoryImpl implements TransactionRepository {
  final client = locator.get<GraphQLService>().client;

  @override
  Future<bool> addTransaction(
    TransactionModel transaction,
    String userId,
  ) async {
    try {
      final response = await client.query(QueryOptions(
        variables: {
          "category": transaction.category,
          "date": DateTime.fromMillisecondsSinceEpoch(transaction.date).toString(),
          "description": transaction.description,
          "status": transaction.status,
          "value": transaction.value,
          "user_id": userId,
        },
        document: gql(mAddNewTransaction),
      ));
      final parsedData = TransactionModel.fromMap(response.data?["insert_transaction_one"] ?? {});

      if (parsedData.id != null) {
        return true;
      }
      throw Exception(response.exception);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final response = await client.query(QueryOptions(document: gql(qGetAllTransactions)));

      final parsedData = List.from(response.data?['transaction'] ?? []);

      final transactions = parsedData.map((e) => TransactionModel.fromMap(e)).toList();
      return transactions;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BalancesModel> getBalances() async {
    try {
      final response = await client.query(QueryOptions(document: gql(qGetBalances)));

      final balances = BalancesModel.fromMap(response.data ?? {});

      return balances;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await client.query(QueryOptions(
        variables: {
          "id": transaction.id,
          "category": transaction.category,
          "date": DateTime.fromMillisecondsSinceEpoch(transaction.date).toString(),
          "description": transaction.description,
          "status": transaction.status,
          "value": transaction.value,
        },
        document: gql(mUpdateTransaction),
      ));
      final parsedData = TransactionModel.fromMap(response.data?["update_transaction_by_pk"] ?? {});

      if (parsedData.id != null) {
        return true;
      }
      throw Exception(response.exception);
    } catch (e) {
      rethrow;
    }
  }
}
