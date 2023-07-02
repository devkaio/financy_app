import 'dart:developer';

import '../../common/constants/constants.dart';
import '../../common/data/data.dart';
import '../../common/extensions/types_ext.dart';
import '../../common/models/models.dart';
import '../../repositories/repositories.dart';
import '../services.dart';

export 'sync_controller.dart';
export 'sync_state.dart';

class SyncService {
  const SyncService({
    required this.connectionService,
    required this.databaseService,
    required this.graphQLService,
    required this.secureStorageService,
  });

  final ConnectionService connectionService;
  final DatabaseService databaseService;
  final GraphQLService graphQLService;
  final SecureStorageService secureStorageService;

  /// Fetch remote information and perform sync from server
  /// with local database. At the end of the process it sets `NEED_SYNC` to `false`.
  Future<DataResult<void>> syncFromServer() async {
    log('syncFromServer called', name: 'INFO');
    await connectionService.checkConnection();
    if (!connectionService.isConnected) return DataResult.success(null);
    final needSync = await secureStorageService.readOne(key: 'NEED_SYNC');
    if (needSync != null && !needSync.toBool()) return DataResult.success(null);

    try {
      await databaseService.init();

      await _syncBalanceFromServer();
      await _syncTransactionsFromServer();
      await secureStorageService.write(
        key: 'NEED_SYNC',
        value: false.toString(),
      );

      return DataResult.success(null);
    } catch (e) {
      log('syncFromServer exception $e', name: 'ERROR');
      return DataResult.failure(const SyncException(code: 'error'));
    }
  }

  /// Perform sync from server and saves transactions to local database,
  /// setting transactions with [SyncStatus.synced].
  Future<void> _syncTransactionsFromServer() async {
    final clock = Stopwatch();

    log('_syncTransactions called', name: 'INFO');

    final localTransactions = await _getLocalTransactions();

    if (localTransactions.isNotEmpty) return;

    final transactionsFromServerResponse = await graphQLService.read(
      path: Queries.qGetTrasactions,
    );

    final parsedTransactionsFromServer =
        List.from(transactionsFromServerResponse['transaction'] ?? []);

    final transactionsFromServer = parsedTransactionsFromServer
        .map((e) => TransactionModel.fromMap(e))
        .toList();

    if (transactionsFromServer.isEmpty) return;

    clock.start();

    for (var t in transactionsFromServer) {
      await saveLocalChanges(
        path: TransactionRepository.transactionsPath,
        params: t.copyWith(syncStatus: SyncStatus.synced).toDatabase(),
      );
    }

    clock.stop();
    log('total sync time: ${clock.elapsed.inSeconds}',
        name: 'Sync Transactions from Server');
  }

  // Sync balance from server to local database
  Future<void> _syncBalanceFromServer() async {
    log('_syncBalance called', name: 'INFO');
    final localBalanceResponse =
        (await databaseService.read(path: TransactionRepository.balancesPath));

    if ((localBalanceResponse['data'] as List).isNotEmpty) return;

    final remoteBalanceResponse =
        await graphQLService.read(path: Queries.qGetBalances);

    final balances = BalancesModel.fromMap(remoteBalanceResponse);

    await saveLocalChanges(
      path: TransactionRepository.balancesPath,
      params: balances.toMap(),
    );
  }

  /// Helper method to save changes to local database and set
  /// `NEED_SYNC` to `true`.
  Future<void> saveLocalChanges({
    required String path,
    required Map<String, Object?> params,
  }) async {
    final response = await databaseService.create(
      path: path,
      params: params,
    );

    if (!(response['data'] as bool)) {
      throw const CacheException(code: 'write');
    }

    await secureStorageService.write(
      key: 'NEED_SYNC',
      value: true.toString(),
    );
  }

  /// Check all local transactions and perform sync to server
  /// based on the [SyncStatus] of each transaction. If a transaction is marked as
  /// `SyncStatus.delete`, then it is removed from local database after sync and move to next
  /// item on the list.
  ///
  /// At the end of the process it sets `NEED_SYNC` to `false`.
  Future<DataResult<void>> syncToServer() async {
    log('syncToServer called', name: 'INFO');
    await connectionService.checkConnection();

    if (!connectionService.isConnected) return DataResult.success(null);

    List<TransactionModel> localTransactions = await _getLocalTransactions();

    if (localTransactions.isEmpty) return DataResult.success(null);

    try {
      for (final t in localTransactions) {
        await _syncLocalTransactionsToServer(t);
        if (t.syncStatus == SyncStatus.delete) {
          databaseService.delete(
              path: TransactionRepository.transactionsPath,
              params: {'id': t.id});

          continue;
        }
        await saveLocalChanges(
          path: TransactionRepository.transactionsPath,
          params: t.copyWith(syncStatus: SyncStatus.synced).toDatabase(),
        );
      }

      await secureStorageService.write(
        key: 'NEED_SYNC',
        value: false.toString(),
      );

      return DataResult.success(null);
    } catch (e) {
      log('syncToServer exception $e', name: 'ERROR');
      return DataResult.failure(const SyncException(code: 'error'));
    }
  }

  /// Gets all local database saved transactions that are marked as "syncable".
  /// In this case, when the [SyncStatus] is not `SyncStatus.synced`.
  Future<List<TransactionModel>> _getLocalTransactions() async {
    final response = await databaseService.read(
        path: TransactionRepository.transactionsPath);

    final List<Map<String, dynamic>> transactions = response['data'];

    final parsedTransactions = transactions.map((change) {
      return TransactionModel.fromMap(change);
    }).toList();

    final localChanges = parsedTransactions
        .where((t) => t.syncStatus != SyncStatus.synced)
        .toList();

    return localChanges;
  }

  ///Performs server sync calls based on [SyncStatus].
  Future<void> _syncLocalTransactionsToServer(
      TransactionModel localTransaction) async {
    log('_syncLocalTransactionsToServer called', name: 'INFO');
    try {
      var response = {};

      switch (localTransaction.syncStatus) {
        case SyncStatus.create:
          response = await graphQLService.create(
            path: Mutations.mAddNewTransaction,
            params: localTransaction.toMap(),
          );
          break;
        case SyncStatus.update:
          final transactionWithoutUserId = localTransaction.toMap();
          transactionWithoutUserId
              .removeWhere((key, value) => key == 'user_id');

          response = await graphQLService.update(
            path: Mutations.mUpdateTransaction,
            params: transactionWithoutUserId,
          );
          break;
        case SyncStatus.delete:
          response = await graphQLService.delete(
              path: Mutations.mDeleteTransaction,
              params: {'id': localTransaction.id});
          break;
        default:
          response = response;
      }

      if (response.isEmpty) {
        throw const SyncException(code: 'error');
      }
    } catch (e) {
      log('_syncLocalTransactionsToServer exception $e', name: 'ERROR');
      rethrow;
    }
  }
}
