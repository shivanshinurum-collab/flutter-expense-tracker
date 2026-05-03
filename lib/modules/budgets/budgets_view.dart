import 'package:expense_app/modules/budgets/budget_controller.dart';
import 'package:expense_app/modules/categories/categories_controller.dart';
import 'package:expense_app/modules/home/date_controller.dart';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../settings/settings_controller.dart';

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateController = Get.find<DateController>();
    final transController = Get.find<TransactionsController>();
    final budgetController = Get.find<BudgetController>();
    final categoriesController = Get.find<CategoriesController>();

    return Obx(() {
      final selectedDate = dateController.selectedDate.value;
      final totalBudget = budgetController.monthlyBudget.value;
      
      final categories = categoriesController.categories;

      final filteredTransactions = transController.transactionsList.where((t) {
        return t.date.year == selectedDate.year && t.date.month == selectedDate.month;
      }).toList();

      final totalSpent = filteredTransactions.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
      final expenseCats = categories.where((c) => !c.isIncome).toList();

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              MyMoneyHeader(
                stats: [
                  MyMoneyStat(label: 'TOTAL BUDGET', value: totalBudget, color: theme.colorScheme.primary),
                  MyMoneyStat(label: 'TOTAL SPENT', value: totalSpent, color: const Color(0xFFF28B82)),
                ],
                selectedDate: selectedDate,
                onDateChanged: (date) => dateController.setDate(date),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () => _showSetTotalBudgetDialog(budgetController, theme),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A4642),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.edit_calendar_outlined, color: Colors.grey),
                        const SizedBox(width: 16),
                        const Text('Monthly Budget', style: TextStyle(color: Colors.white, fontSize: 16)),
                        const Spacer(),
                        Obx(() {
                          final settingsController = Get.find<SettingsController>();
                          final currentMonthlyBudget = budgetController.monthlyBudget.value;
                          return Text('${settingsController.currencySymbol.value}${currentMonthlyBudget.toStringAsFixed(0)}', style: GoogleFonts.outfit(color: theme.colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold));
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: expenseCats.length,
                  itemBuilder: (context, index) {
                    return _buildBudgetCategoryRow(context, expenseCats[index], theme);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showSetTotalBudgetDialog(BudgetController controller, ThemeData theme) {
    final textController = TextEditingController(text: controller.monthlyBudget.value.toStringAsFixed(0));
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF4A4642),
        title: const Text('Set Monthly Budget', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter amount',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixText: '${Get.find<SettingsController>().currencySymbol.value} ',
            prefixStyle: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(textController.text) ?? 0.0;
              controller.updateBudget(amount);
              Get.back();
            },
            child: Text('SAVE', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  void _showSetBudgetDialog(Category category, ThemeData theme) {
    final budgetController = Get.find<BudgetController>();
    final settingsController = Get.find<SettingsController>();
    final currentBudget = budgetController.getCategoryBudget(category.id);
    final textController = TextEditingController(text: currentBudget > 0 ? currentBudget.toStringAsFixed(0) : '');

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF4A4642),
        title: Center(
          child: Text(currentBudget > 0 ? 'Edit budget' : 'Set budget', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: Icon(_getCategoryIcon(category.name), color: theme.colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(category.name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Limit ', style: TextStyle(color: Color(0xFFE8E5A2))),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixText: '${settingsController.currencySymbol.value} ',
                        prefixStyle: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE8E5A2)),
                    ),
                    child: const Text('CANCEL', style: TextStyle(color: Color(0xFFE8E5A2))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final amount = double.tryParse(textController.text) ?? 0.0;
                      budgetController.setCategoryBudget(category.id, amount);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8E5A2),
                    ),
                    child: Text(currentBudget > 0 ? 'UPDATE' : 'SET', style: const TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'Entertainment': return Icons.movie_outlined;
      case 'Food': return Icons.restaurant;
      case 'Health': return Icons.favorite_border;
      case 'Home': return Icons.home_outlined;
      case 'Insurance': return Icons.verified_user_outlined;
      case 'Shopping': return Icons.shopping_cart_outlined;
      case 'Social': return Icons.people_outline;
      case 'Sport': return Icons.sports_tennis_outlined;
      case 'Tax': return Icons.receipt_long_outlined;
      case 'Telephone': return Icons.phone_android_outlined;
      case 'Transportation': return Icons.directions_bus_outlined;
      default: return Icons.category_outlined;
    }
  }

  Widget _buildBudgetCategoryRow(BuildContext context, Category category, ThemeData theme) {
    final budgetController = Get.find<BudgetController>();
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final categoryBudget = budgetController.getCategoryBudget(category.id);

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white10,
              child: Icon(_getCategoryIcon(category.name), color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                category.name,
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.white),
              ),
            ),
            if (categoryBudget > 0)
              Text(
                '${settingsController.currencySymbol.value}${categoryBudget.toStringAsFixed(0)}',
                style: GoogleFonts.outfit(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              )
            else
              OutlinedButton(
                onPressed: () => _showSetBudgetDialog(category, theme),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text('SET BUDGET', style: TextStyle(color: theme.colorScheme.primary, fontSize: 12)),
              ),
            const SizedBox(width: 8),
            PopupMenuButton(
              icon: const Icon(Icons.more_horiz, color: Colors.grey),
              color: const Color(0xFF4A4642),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit Budget', style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuItem(
                  value: 'clear',
                  child: Text('Clear Budget', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showSetBudgetDialog(category, theme);
                } else if (value == 'clear') {
                  budgetController.setCategoryBudget(category.id, 0.0);
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
