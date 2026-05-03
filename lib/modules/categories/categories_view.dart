import 'package:expense_app/modules/accounts/accounts_controller.dart';
import 'package:expense_app/modules/categories/categories_controller.dart';
import 'package:expense_app/modules/home/date_controller.dart';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../settings/settings_controller.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    var isIncome = false.obs;
    final categoriesController = Get.find<CategoriesController>();

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF4A4642),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add new category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Category name',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE8E5A2))),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Expense'),
                      selected: !isIncome.value,
                      onSelected: (val) => isIncome.value = false,
                      selectedColor: const Color(0xFFE8E5A2),
                      labelStyle: TextStyle(color: !isIncome.value ? Colors.black : Colors.white),
                    ),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: const Text('Income'),
                      selected: isIncome.value,
                      onSelected: (val) => isIncome.value = true,
                      selectedColor: const Color(0xFFE8E5A2),
                      labelStyle: TextStyle(color: isIncome.value ? Colors.black : Colors.white),
                    ),
                  ],
                )),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE8E5A2))),
                        child: const Text('CANCEL', style: TextStyle(color: Color(0xFFE8E5A2))),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isNotEmpty) {
                            final category = Category(
                              id: const Uuid().v4(),
                              name: nameController.text.trim(),
                              iconPath: 'assets/icons/default.png',
                              isIncome: isIncome.value,
                            );
                            await categoriesController.addCategory(category);
                            Get.back();
                          } else {
                            Get.snackbar('Error', 'Please enter a category name', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8E5A2)),
                        child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateController = Get.find<DateController>();
    final transController = Get.find<TransactionsController>();
    final categoriesController = Get.find<CategoriesController>();

    return Obx(() {
      final selectedDate = dateController.selectedDate.value;
      
      if (categoriesController.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final categories = categoriesController.categories;

      final filteredTransactions = transController.transactionsList.where((t) {
        return t.date.year == selectedDate.year && t.date.month == selectedDate.month;
      }).toList();

      final totalExpense = filteredTransactions.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
      final totalIncome = filteredTransactions.where((t) => t.isIncome).fold(0.0, (sum, item) => sum + item.amount);

      final incomeCats = categories.where((c) => c.isIncome).toList();
      final expenseCats = categories.where((c) => !c.isIncome).toList();

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              MyMoneyHeader(
                stats: [
                  MyMoneyStat(label: 'EXPENSE SO FAR', value: totalExpense, color: const Color(0xFFF28B82)),
                  MyMoneyStat(label: 'INCOME SO FAR', value: totalIncome, color: const Color(0xFF81C995)),
                ],
                selectedDate: selectedDate,
                onDateChanged: (date) => dateController.setDate(date),
                showDateSelector: false,
              ),
              // Obx(() {
              //   final settingsController = Get.find<SettingsController>();
              //   final totalBalance = Get.find<AccountsController>().accounts.fold(0.0, (sum, item) => sum + item.balance);
              //   return Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8),
              //     child: Text(
              //       '[ Total Combined Balance: ${settingsController.currencySymbol.value}${totalBalance.toStringAsFixed(2)} ]',
              //       style: GoogleFonts.outfit(color: theme.colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold),
              //     ),
              //   );
              // }),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryHeader('Income categories', theme),
                      ...incomeCats.map((cat) {
                        final catAmount = filteredTransactions
                            .where((t) => t.category == cat.name)
                            .fold(0.0, (sum, item) => sum + item.amount);
                        return _buildCategoryTile(cat, theme, categoriesController, catAmount);
                      }),
                      const SizedBox(height: 16),
                      _buildCategoryHeader('Expense categories', theme),
                      ...expenseCats.map((cat) {
                        final catAmount = filteredTransactions
                            .where((t) => t.category == cat.name)
                            .fold(0.0, (sum, item) => sum + item.amount);
                        return _buildCategoryTile(cat, theme, categoriesController, catAmount);
                      }),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: OutlinedButton(
                          onPressed: () => _showAddCategoryDialog(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.colorScheme.primary),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text('ADD NEW CATEGORY', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCategoryHeader(String title, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: GoogleFonts.outfit(color: theme.colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(color: Colors.grey, thickness: 0.5),
      ],
    );
  }

  IconData _getCategoryIcon(String name) {
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
      case 'Baby': return Icons.child_care;
      case 'Beauty': return Icons.face_retouching_natural;
      case 'Gift': return Icons.card_giftcard;
      case 'Education': return Icons.school_outlined;
      case 'Salary': return Icons.payments_outlined;
      case 'Bonus': return Icons.redeem_outlined;
      case 'Awards': return Icons.emoji_events_outlined;
      case 'Grants': return Icons.monetization_on_outlined;
      case 'Rental': return Icons.home_work_outlined;
      case 'Refunds': return Icons.history_outlined;
      case 'Lottery': return Icons.confirmation_number_outlined;
      case 'Coupons': return Icons.local_offer_outlined;
      case 'Sale': return Icons.sell_outlined;
      default: return Icons.category_outlined;
    }
  }

  Widget _buildCategoryTile(Category cat, ThemeData theme, CategoriesController controller, double amount) {
    final settingsController = Get.find<SettingsController>();
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: Icon(_getCategoryIcon(cat.name), color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(cat.name, style: GoogleFonts.outfit(fontSize: 16, color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Text(
            '${settingsController.currencySymbol.value}${amount.toStringAsFixed(2)}',
            style: GoogleFonts.outfit(
              color: cat.isIncome ? const Color(0xFF81C995) : const Color(0xFFF28B82),
              fontWeight: FontWeight.bold,
            ),
          )),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: Colors.grey),
            color: const Color(0xFF4A4642),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(cat, controller);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {},
    );
  }

  void _showDeleteConfirmation(Category cat, CategoriesController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF4A4642),
        title: const Text('Delete Category', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${cat.name}"?', style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              controller.deleteCategory(cat.id);
              Get.back();
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
