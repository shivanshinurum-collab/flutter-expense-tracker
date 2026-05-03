import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BudgetController extends GetxController {
  final RxDouble monthlyBudget = 0.0.obs;
  // Map of categoryId to budget amount
  final RxMap<String, double> categoryBudgets = <String, double>{}.obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    monthlyBudget.value = _prefs.getDouble('monthly_budget') ?? 50000.0;
    
    final String? budgetsJson = _prefs.getString('category_budgets');
    if (budgetsJson != null) {
      final Map<String, dynamic> decoded = json.decode(budgetsJson);
      categoryBudgets.assignAll(decoded.map((key, value) => MapEntry(key, (value as num).toDouble())));
    }
  }

  Future<void> updateBudget(double newBudget) async {
    await _prefs.setDouble('monthly_budget', newBudget);
    monthlyBudget.value = newBudget;
  }

  Future<void> setCategoryBudget(String categoryId, double amount) async {
    categoryBudgets[categoryId] = amount;
    await _prefs.setString('category_budgets', json.encode(categoryBudgets));
  }

  double getCategoryBudget(String categoryId) {
    return categoryBudgets[categoryId] ?? 0.0;
  }
}
