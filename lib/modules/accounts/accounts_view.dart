import 'package:expense_app/modules/accounts/accounts_controller.dart';
import 'package:expense_app/modules/home/date_controller.dart';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../settings/settings_controller.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  void _showAddAccountDialog() {
    final amountController = TextEditingController();
    final nameController = TextEditingController();
    var selectedIcon = Icons.account_balance_wallet.obs;
    final accountsController = Get.find<AccountsController>();

    Get.dialog(
      Obx(() => AlertDialog(
            backgroundColor: const Color(0xFF4A4642),
            title: const Center(
              child: Text('Add new account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Initial amount  ', style: TextStyle(color: Color(0xFFE8E5A2))),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade700),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('*Initial amount will not be reflected in\nanalysis', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Name  ', style: TextStyle(color: Color(0xFFE8E5A2))),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade700),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Untitled',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Icon', style: TextStyle(color: Color(0xFFE8E5A2))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconOption(Icons.money, selectedIcon.value == Icons.money, () => selectedIcon.value = Icons.money),
                      _buildIconOption(Icons.credit_card, selectedIcon.value == Icons.credit_card, () => selectedIcon.value = Icons.credit_card),
                      _buildIconOption(Icons.savings, selectedIcon.value == Icons.savings, () => selectedIcon.value = Icons.savings),
                      _buildIconOption(Icons.account_balance, selectedIcon.value == Icons.account_balance, () => selectedIcon.value = Icons.account_balance),
                      _buildIconOption(Icons.payment, selectedIcon.value == Icons.payment, () => selectedIcon.value = Icons.payment),
                    ],
                  ),
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
                        onPressed: () async {
                          if (nameController.text.isNotEmpty) {
                            final account = Account(
                              id: const Uuid().v4(),
                              name: nameController.text,
                              balance: double.tryParse(amountController.text) ?? 0.0,
                              iconPath: 'assets/icons/default.png',
                            );
                            await accountsController.addAccount(account);
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8E5A2),
                        ),
                        child: const Text('SAVE', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  static Widget _buildIconOption(IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8E5A2).withOpacity(0.2) : Colors.transparent,
          border: isSelected ? Border.all(color: const Color(0xFFE8E5A2)) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: isSelected ? const Color(0xFFE8E5A2) : Colors.white, size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateController = Get.find<DateController>();
    final transController = Get.find<TransactionsController>();
    final accountsController = Get.find<AccountsController>();

    return Obx(() {
      final selectedDate = dateController.selectedDate.value;
      
      if (accountsController.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final accounts = accountsController.accounts;
      final allTransactions = transController.transactionsList;

      // Calculate dynamic balances
      final Map<String, double> dynamicBalances = {};
      for (var acc in accounts) {
        // Start with initial balance
        double balance = acc.balance; 
        
        // Add/Subtract transactions
        final accTransactions = allTransactions.where((t) => t.account == acc.name);
        for (var t in accTransactions) {
          if (t.isIncome) {
            balance += t.amount;
          } else {
            balance -= t.amount;
          }
        }
        dynamicBalances[acc.id] = balance;
      }

      final filteredTransactions = transController.transactionsList.where((t) {
        return t.date.year == selectedDate.year && t.date.month == selectedDate.month;
      }).toList();

      final totalExpense = filteredTransactions.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
      final totalIncome = filteredTransactions.where((t) => t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
      final totalBalance = dynamicBalances.values.fold(0.0, (sum, item) => sum + item);

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
              Obx(() {
                final settingsController = Get.find<SettingsController>();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '[ Total Combined Balance: ${settingsController.currencySymbol.value}${totalBalance.toStringAsFixed(2)} ]',
                    style: GoogleFonts.outfit(color: theme.colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Accounts',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final acc = accounts[index];
                    return _buildAccountCard(context, acc, dynamicBalances[acc.id] ?? 0.0, theme);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                  onPressed: _showAddAccountDialog,
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
                      Text('ADD NEW ACCOUNT', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
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

  Widget _buildAccountCard(BuildContext context, Account account, double dynamicBalance, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.account_balance_wallet_outlined, color: theme.colorScheme.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Obx(() {
                  final settingsController = Get.find<SettingsController>();
                  return Text(
                    'Balance: ${settingsController.currencySymbol.value}${dynamicBalance.toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(color: theme.colorScheme.primary, fontSize: 16),
                  );
                }),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
