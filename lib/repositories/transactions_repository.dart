import 'package:flutter/foundation.dart';
import 'package:expense_app/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqf;

class TransactionsRepository {
  static const _tableName = 'transactions';
  late String _dbPath;
  late sqf.Database _db;
  
  // Web Fallback
  List<Transaction> _webMockList = [];

  Future<List<Transaction>> loadTransactions() async {
    if (kIsWeb) {
      return _webMockList;
    }
    
    _dbPath = join(await sqf.getDatabasesPath(), 'transactions_data.db');
    try {
      final dbAlreadyExists = await sqf.databaseExists(_dbPath);
      if (dbAlreadyExists) {
        _db = await sqf.openDatabase(_dbPath, version: 2);
        return await getAllTransactions();
      } else {
        _db = await sqf.openDatabase(
          _dbPath,
          version: 2,
          onCreate: (db, version) {
            return db.execute(
                'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, title TEXT, amount TEXT, date INTEGER, createdOn INTEGER, imagePath TEXT, category TEXT, isIncome INTEGER DEFAULT 0)');
          },
        );
        return [];
      }
    } catch (e) {
      throw Exception('Unable to create/get database.');
    }
  }

  Future<List<Transaction>> getAllTransactions() async {
    if (kIsWeb) {
      return _webMockList;
    }
    try {
      final List<Map<String, dynamic>> tList =
          await _db.query(_tableName, orderBy: 'date');
      final List<Transaction> transactions = tList
          .map((tMap) => Transaction.fromMap(Map<String, dynamic>.from(tMap)))
          .toList();
      return transactions;
    } catch (e) {
      throw Exception('Unable to get transactions.');
    }
  }

  Future<List<Transaction>> addTransaction(
      {required List<Transaction> list, required Transaction addT}) async {
    if (kIsWeb) {
      _webMockList.add(addT);
      return List.from(_webMockList);
    }
    try {
      await _db.insert(_tableName, addT.toMap(),
          conflictAlgorithm: sqf.ConflictAlgorithm.replace);
      return await getAllTransactions();
    } catch (e) {
      throw Exception('Unable to get add transaction.');
    }
  }

  Future<List<Transaction>> removeTransaction(
      {required List<Transaction> list, required String remTID}) async {
    if (kIsWeb) {
      _webMockList.removeWhere((element) => element.id == remTID);
      return List.from(_webMockList);
    }
    try {
      await _db.delete(_tableName, where: 'id = ?', whereArgs: [remTID]);
      return await getAllTransactions();
    } catch (e) {
      throw Exception('Unable to get delete transaction.');
    }
  }

  Future<List<Transaction>> filterTransactions({required String keyword}) async {
    if (kIsWeb) {
      return _webMockList
          .where((element) =>
              element.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    try {
      final filtered = await _db
          .query(_tableName, where: 'title LIKE ?', whereArgs: ['%$keyword%']);
      final list = filtered.map((e) => Transaction.fromMap(e)).toList();
      return list;
    } catch (e) {
      throw Exception('Unable to filter transactions.');
    }
  }

  Future<bool> updateTransaction({required Transaction transaction}) async {
    if (kIsWeb) {
      final index =
          _webMockList.indexWhere((element) => element.id == transaction.id);
      if (index != -1) {
        _webMockList[index] = transaction;
      }
      return true;
    }
    try {
      await _db.update(_tableName, transaction.toMap(),
          where: 'id = ?', whereArgs: [transaction.id]);
      return true;
    } catch (e) {
      throw Exception('Unable to update transaction.');
    }
  }
}


