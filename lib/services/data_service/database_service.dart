import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '../../common/data/data.dart';
import '../../locator.dart';
import 'data_service.dart';

class DatabaseService implements DataService<Map<String, dynamic>> {
  DatabaseService();

  static const _name = 'financy_app.db';
  Database? _db;

  Database get db => _db!;

  ///Delete database. Must be called after [init] otherwise null check exception is thrown.
  Future<void> get deleteDB async {
    log('DELETING DATABASE', name: 'INFO', time: DateTime.now());
    _db = null;

    await deleteDatabase(_name);
  }

  ///Initialize local database
  Future<DatabaseService> init() async {
    log('init called', name: 'INFO');

    _db = await openDatabase(_name);

    _db?.execute(
        'CREATE TABLE IF NOT EXISTS transactions (id TEXT PRIMARY KEY, description TEXT, category TEXT, status INTEGER, value NUMERIC, date TEXT, created_at TEXT, user_id TEXT, sync_status TEXT)');

    _db?.execute(
        'CREATE TABLE IF NOT EXISTS balances (total_balance NUMERIC, total_income NUMERIC, total_outcome NUMERIC)');

    return this;
  }

  @override
  Future<Map<String, dynamic>> create({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final db = locator<DatabaseService>().db;

      if (params.containsKey('id')) {
        final id = params['id'];
        final count = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) from $path WHERE id = ?',
            [id],
          ),
        );

        if (count != null && count > 0) {
          final result = await db.update(
            path,
            params,
            where: 'id = ?',
            whereArgs: [id],
          );
          return {'data': result != 0};
        } else {
          final result = await db.insert(
            path,
            params,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          return {'data': result != 0};
        }
      } else {
        final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) from $path'),
        );

        if (count != null && count > 0) {
          final result = await db.update(path, params);
          return {'data': result != 0};
        } else {
          final result = await db.insert(
            path,
            params,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          return {'data': result != 0};
        }
      }
    } catch (e) {
      throw const CacheException(code: 'write');
    }
  }

  @override
  Future<Map<String, dynamic>> read({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final db = locator<DatabaseService>().db;

      if (params.containsKey('id')) {
        final result = await db.query(
          path,
          where: 'id = ?',
          whereArgs: [params['id']],
        );
        return {'data': result};
      } else {
        String whereClause = '';
        List<dynamic> whereArgs = [];

        if (params.containsKey('start_date') &&
            params.containsKey('end_date')) {
          whereClause = 'date BETWEEN ? AND ?';
          whereArgs = [params['start_date'], params['end_date']];
        }

        if (params.containsKey('skip_status')) {
          if (whereClause.isNotEmpty) {
            whereClause += ' AND ';
          }
          whereClause += 'sync_status != ?';
          whereArgs.add(params['skip_status']);
        }

        final result = await db.query(
          path,
          limit: params['limit'],
          offset: params['offset'],
          orderBy: params['order_by'],
          where: whereClause.isEmpty ? null : whereClause,
          whereArgs: whereArgs.isEmpty ? null : whereArgs,
        );
        return {'data': result};
      }
    } catch (e) {
      throw const CacheException(code: 'read');
    }
  }

  @override
  Future<Map<String, dynamic>> update({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final db = locator<DatabaseService>().db;

      if (params.containsKey('id')) {
        final id = params['id'];

        final result = await db.update(
          path,
          params,
          where: 'id = ?',
          whereArgs: [id],
        );
        return {'data': result != 0};
      } else {
        final result = await db.update(path, params);
        return {'data': result != 0};
      }
    } catch (e) {
      throw const CacheException(code: 'update');
    }
  }

  @override
  Future<Map<String, dynamic>> delete({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final db = locator<DatabaseService>().db;

      if (params.containsKey('id')) {
        final result = await db.delete(
          path,
          where: 'id = ?',
          whereArgs: [params['id']],
        );

        return {'data': result != 0};
      } else {
        final result = await db.delete(path);

        return {'data': result != 0};
      }
    } catch (e) {
      throw const CacheException(code: 'delete');
    }
  }
}
