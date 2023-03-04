import 'package:graphql_flutter/graphql_flutter.dart';

import '../common/constants/queries/get_all_transactions.dart';
import '../common/constants/queries/get_balances.dart';
import '../common/models/balances_model.dart';
import '../common/models/transaction_model.dart';
import '../locator.dart';
import '../services/graphql_service.dart';

abstract class TransactionRepository {
  Future<void> addTransaction();
  Future<List<TransactionModel>> getAllTransactions();

  Future<BalancesModel> getBalances();
}

class TransactionRepositoryImpl implements TransactionRepository {
  final client = locator.get<GraphQLService>().client;

  @override
  Future<void> addTransaction() {
    // TODO: implement addTransaction
    throw UnimplementedError();
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
}
