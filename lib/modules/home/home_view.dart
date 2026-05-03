import 'package:expense_app/modules/home/date_controller.dart';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:expense_app/modules/other/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  void _startAddNewTransaction() {
    Get.to(() => const CalculatorInputPage());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateController = Get.find<DateController>();
    final transController = Get.find<TransactionsController>();

    return Obx(() {
      final selectedDate = dateController.selectedDate.value;
      final filteredTransactions = transController.transactionsList.where((t) {
        return t.date.year == selectedDate.year && t.date.month == selectedDate.month;
      }).toList();

      final totalExpense = filteredTransactions.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
      final totalIncome = filteredTransactions.where((t) => t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
      final balance = totalIncome - totalExpense;

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              MyMoneyHeader(
                stats: [
                  MyMoneyStat(label: 'EXPENSE', value: totalExpense, color: const Color(0xFFF28B82)),
                  MyMoneyStat(label: 'INCOME', value: totalIncome, color: const Color(0xFF81C995)),
                  MyMoneyStat(label: 'TOTAL', value: balance, color: const Color(0xFF81C995)),
                ],
                selectedDate: selectedDate,
                onDateChanged: (date) => dateController.setDate(date),
              ),
              Expanded(
                child: filteredTransactions.isEmpty
                    ? _buildEmptyState(context)
                    : _buildTransactionList(filteredTransactions, theme, transController),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _startAddNewTransaction,
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  Widget _buildTransactionList(List<Transaction> transactions, ThemeData theme, TransactionsController controller) {
    // Group by date
    Map<String, List<Transaction>> grouped = {};
    for (var t in transactions) {
      String dateKey = DateFormat('yyyy-MM-dd').format(t.date);
      if (grouped[dateKey] == null) grouped[dateKey] = [];
      grouped[dateKey]!.add(t);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final dateTransactions = grouped[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                DateFormat('MMMM dd, EEEE').format(date),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ...dateTransactions.map((t) => TransactionItem(
                  transaction: t,
                  deleteTransaction: (id) => controller.removeTransaction(id),
                )),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_late_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No record in this month. Tap + to add new expense or income.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
