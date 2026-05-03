import 'package:get/get.dart';
import 'package:expense_app/models/models.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:path/path.dart';

class TransactionsController extends GetxController {
  final RxList<Transaction> transactionsList = <Transaction>[].obs;
  final RxBool isLoading = false.obs;
  
  sqf.Database? _db;

  @override
  void onInit() {
    super.onInit();
    initDbAndLoad();
  }

  Future<void> initDbAndLoad() async {
    isLoading.value = true;
    final dbPath = join(await sqf.getDatabasesPath(), 'transactions_data.db');
    _db = await sqf.openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE transactions(id TEXT PRIMARY KEY, title TEXT, amount TEXT, date INTEGER, createdOn INTEGER, imagePath TEXT, category TEXT, account TEXT, isIncome INTEGER DEFAULT 0)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE transactions ADD COLUMN account TEXT DEFAULT "Cash"');
        }
      },
    );
    await loadTransactions();
  }

  Future<void> loadTransactions() async {
    final List<Map<String, dynamic>> maps = await _db!.query('transactions', orderBy: 'date DESC');
    transactionsList.assignAll(maps.map((e) => Transaction.fromMap(e)).toList());
    isLoading.value = false;
  }

  Future<void> addTransaction(Transaction t) async {
    await _db!.insert('transactions', t.toMap(), conflictAlgorithm: sqf.ConflictAlgorithm.replace);
    await loadTransactions();
  }

  Future<void> removeTransaction(String id) async {
    await _db!.delete('transactions', where: 'id = ?', whereArgs: [id]);
    await loadTransactions();
  }

  Future<void> updateTransaction(Transaction t) async {
    await _db!.update('transactions', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    await loadTransactions();
  }
}
