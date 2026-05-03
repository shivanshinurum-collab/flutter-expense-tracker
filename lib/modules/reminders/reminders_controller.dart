import 'package:get/get.dart';
import 'package:expense_app/models/reminder.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:path/path.dart';

class RemindersController extends GetxController {
  final RxList<Reminder> remindersList = <Reminder>[].obs;
  sqf.Database? _db;

  @override
  void onInit() {
    super.onInit();
    initDbAndLoad();
  }

  Future<void> initDbAndLoad() async {
    final dbPath = join(await sqf.getDatabasesPath(), 'reminders_data.db');
    _db = await sqf.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE reminders(id TEXT PRIMARY KEY, title TEXT, amount REAL, dueDate TEXT, isPaid INTEGER)');
      },
    );
    await loadReminders();
  }

  Future<void> loadReminders() async {
    final List<Map<String, dynamic>> maps = await _db!.query('reminders');
    remindersList.assignAll(maps.map((e) => Reminder.fromMap(e)).toList());
  }

  Future<void> addReminder(Reminder reminder) async {
    await _db!.insert('reminders', reminder.toMap(), conflictAlgorithm: sqf.ConflictAlgorithm.replace);
    await loadReminders();
  }

  Future<void> deleteReminder(String id) async {
    await _db!.delete('reminders', where: 'id = ?', whereArgs: [id]);
    await loadReminders();
  }

  Future<void> togglePaid(Reminder reminder) async {
    final updated = Reminder(
      id: reminder.id,
      title: reminder.title,
      amount: reminder.amount,
      dueDate: reminder.dueDate,
      isPaid: !reminder.isPaid,
    );
    await _db!.update('reminders', updated.toMap(), where: 'id = ?', whereArgs: [updated.id]);
    await loadReminders();
  }
}
