import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesRepository {
  final SharedPreferences _prefs;
  static const _budgetKey = 'monthly_budget';

  UserPreferencesRepository({required SharedPreferences preferences})
      : _prefs = preferences;

  double getMonthlyBudget() {
    return _prefs.getDouble(_budgetKey) ?? 50000.0; // Default budget
  }

  Future<void> setMonthlyBudget(double budget) async {
    await _prefs.setDouble(_budgetKey, budget);
  }
}
