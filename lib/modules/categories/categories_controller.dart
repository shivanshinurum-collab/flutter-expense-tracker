import 'package:get/get.dart';
import 'package:expense_app/models/models.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:path/path.dart';

class CategoriesController extends GetxController {
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;
  
  sqf.Database? _db;

  @override
  void onInit() {
    super.onInit();
    initDbAndLoad();
  }

  Future<void> initDbAndLoad() async {
    isLoading.value = true;
    final dbPath = join(await sqf.getDatabasesPath(), 'categories_data.db');
    _db = await sqf.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE categories(id TEXT PRIMARY KEY, name TEXT, iconPath TEXT, isIncome INTEGER)');
      },
    );

    final count = sqf.Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM categories'));
    if (count == 0) {
      final defaults = [
        Category(id: '1', name: 'Awards', iconPath: 'assets/icons/awards.png', isIncome: true),
        Category(id: '2', name: 'Coupons', iconPath: 'assets/icons/coupons.png', isIncome: true),
        Category(id: '3', name: 'Grants', iconPath: 'assets/icons/grants.png', isIncome: true),
        Category(id: '4', name: 'Lottery', iconPath: 'assets/icons/lottery.png', isIncome: true),
        Category(id: '5', name: 'Refunds', iconPath: 'assets/icons/refunds.png', isIncome: true),
        Category(id: '6', name: 'Rental', iconPath: 'assets/icons/rental.png', isIncome: true),
        Category(id: '7', name: 'Salary', iconPath: 'assets/icons/salary.png', isIncome: true),
        Category(id: '8', name: 'Sale', iconPath: 'assets/icons/sale.png', isIncome: true),
        Category(id: '9', name: 'Baby', iconPath: 'assets/icons/baby.png', isIncome: false),
        Category(id: '10', name: 'Beauty', iconPath: 'assets/icons/beauty.png', isIncome: false),
        Category(id: '11', name: 'Entertainment', iconPath: 'assets/icons/entertainment.png', isIncome: false),
        Category(id: '12', name: 'Food', iconPath: 'assets/icons/food.png', isIncome: false),
        Category(id: '13', name: 'Health', iconPath: 'assets/icons/health.png', isIncome: false),
        Category(id: '14', name: 'Home', iconPath: 'assets/icons/home.png', isIncome: false),
        Category(id: '15', name: 'Insurance', iconPath: 'assets/icons/insurance.png', isIncome: false),
        Category(id: '16', name: 'Shopping', iconPath: 'assets/icons/shopping.png', isIncome: false),
        Category(id: '17', name: 'Social', iconPath: 'assets/icons/social.png', isIncome: false),
        Category(id: '18', name: 'Sport', iconPath: 'assets/icons/sport.png', isIncome: false),
        Category(id: '19', name: 'Tax', iconPath: 'assets/icons/tax.png', isIncome: false),
        Category(id: '20', name: 'Telephone', iconPath: 'assets/icons/telephone.png', isIncome: false),
        Category(id: '21', name: 'Transportation', iconPath: 'assets/icons/transportation.png', isIncome: false),
        Category(id: '99', name: 'Others', iconPath: 'assets/icons/default.png', isIncome: false),
      ];
      for (var cat in defaults) {
        await _db!.insert('categories', cat.toMap());
      }
    }
    await loadCategories();
  }

  Future<void> loadCategories() async {
    final List<Map<String, dynamic>> maps = await _db!.query('categories');
    categories.assignAll(maps.map((e) => Category.fromMap(e)).toList());
    isLoading.value = false;
  }

  Future<void> addCategory(Category category) async {
    await _db!.insert('categories', category.toMap(), conflictAlgorithm: sqf.ConflictAlgorithm.replace);
    await loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _db!.delete('categories', where: 'id = ?', whereArgs: [id]);
    await loadCategories();
  }
}
