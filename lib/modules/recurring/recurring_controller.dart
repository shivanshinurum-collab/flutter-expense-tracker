import 'package:get/get.dart';
import 'package:expense_app/models/recurring_transaction.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:path/path.dart';

class RecurringController extends GetxController {
  final RxList<RecurringTransaction> recurringList = <RecurringTransaction>[].obs;
  sqf.Database? _db;

  @override
  void onInit() {
    super.onInit();
    initDbAndLoad();
  }

  Future<void> initDbAndLoad() async {
    final dbPath = join(await sqf.getDatabasesPath(), 'recurring_data.db');
    _db = await sqf.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE recurring_transactions(id TEXT PRIMARY KEY, title TEXT, amount REAL, category TEXT, account TEXT, isIncome INTEGER, frequency INTEGER, nextOccurrence TEXT, isActive INTEGER)');
      },
    );
    await loadRecurring();
  }

  Future<void> loadRecurring() async {
    final List<Map<String, dynamic>> maps = await _db!.query('recurring_transactions');
    recurringList.assignAll(maps.map((e) => RecurringTransaction.fromMap(e)).toList());
  }

  Future<void> addRecurring(RecurringTransaction recurring) async {
    await _db!.insert('recurring_transactions', recurring.toMap(), conflictAlgorithm: sqf.ConflictAlgorithm.replace);
    await loadRecurring();
  }

  Future<void> deleteRecurring(String id) async {
    await _db!.delete('recurring_transactions', where: 'id = ?', whereArgs: [id]);
    await loadRecurring();
  }

  Future<void> toggleActive(RecurringTransaction recurring) async {
    final updated = RecurringTransaction(
      id: recurring.id,
      title: recurring.title,
      amount: recurring.amount,
      category: recurring.category,
      account: recurring.account,
      isIncome: recurring.isIncome,
      frequency: recurring.frequency,
      nextOccurrence: recurring.nextOccurrence,
      isActive: !recurring.isActive,
    );
    await _db!.update('recurring_transactions', updated.toMap(), where: 'id = ?', whereArgs: [updated.id]);
    await loadRecurring();
  }
}
