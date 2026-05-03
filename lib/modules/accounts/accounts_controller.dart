import 'package:get/get.dart';
import 'package:expense_app/models/models.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:path/path.dart';

class AccountsController extends GetxController {
  final RxList<Account> accounts = <Account>[].obs;
  final RxBool isLoading = false.obs;
  
  sqf.Database? _db;

  @override
  void onInit() {
    super.onInit();
    initDbAndLoad();
  }

  Future<void> initDbAndLoad() async {
    isLoading.value = true;
    final dbPath = join(await sqf.getDatabasesPath(), 'accounts_data.db');
    _db = await sqf.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE accounts(id TEXT PRIMARY KEY, name TEXT, balance REAL, iconPath TEXT)');
      },
    );

    final count = sqf.Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM accounts'));
    if (count == 0) {
      await _db!.insert('accounts', Account(id: '1', name: 'Card', balance: 0.0, iconPath: 'assets/icons/card.png').toMap());
      await _db!.insert('accounts', Account(id: '2', name: 'Cash', balance: 0.0, iconPath: 'assets/icons/cash.png').toMap());
      await _db!.insert('accounts', Account(id: '3', name: 'Savings', balance: 0.0, iconPath: 'assets/icons/savings.png').toMap());
      await _db!.insert('accounts', Account(id: '4', name: 'Wallet', balance: 0.0, iconPath: 'assets/icons/wallet.png').toMap());
      await _db!.insert('accounts', Account(id: '5', name: 'Investment', balance: 0.0, iconPath: 'assets/icons/investment.png').toMap());
    }
    await loadAccounts();
  }

  Future<void> loadAccounts() async {
    final List<Map<String, dynamic>> maps = await _db!.query('accounts');
    accounts.assignAll(maps.map((e) => Account.fromMap(e)).toList());
    isLoading.value = false;
  }

  Future<void> addAccount(Account account) async {
    await _db!.insert('accounts', account.toMap(), conflictAlgorithm: sqf.ConflictAlgorithm.replace);
    await loadAccounts();
  }

  Future<void> updateAccountBalance(String accountName, double amount, bool isIncome) async {
    final account = accounts.firstWhereOrNull((a) => a.name == accountName);
    if (account != null) {
      final newBalance = isIncome ? account.balance + amount : account.balance - amount;
      await _db!.update('accounts', {'balance': newBalance}, where: 'id = ?', whereArgs: [account.id]);
      await loadAccounts();
    }
  }

  Future<void> deleteAccount(String id) async {
    await _db!.delete('accounts', where: 'id = ?', whereArgs: [id]);
    await loadAccounts();
  }
}
