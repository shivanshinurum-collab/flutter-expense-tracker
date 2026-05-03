import 'package:expense_app/modules/home/date_controller.dart';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

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
                  MyMoneyStat(label: 'TOTAL', value: balance, color: theme.colorScheme.primary),
                ],
                selectedDate: selectedDate,
                onDateChanged: (date) => dateController.setDate(date),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildSummaryCard(context, totalIncome, totalExpense, balance),
                      const SizedBox(height: 24),
                      _buildOverviewToggle(context, theme),
                      const SizedBox(height: 24),
                      if (filteredTransactions.isEmpty)
                        _buildEmptyState(context)
                      else ...[
                        _buildChartSection(context, filteredTransactions),
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildSummaryCard(BuildContext context, double income, double expense, double balance) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4642),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('Income', income, const Color(0xFF81C995)),
          Container(height: 30, width: 1, color: Colors.white10),
          _buildSummaryItem('Expense', expense, const Color(0xFFF28B82)),
          Container(height: 30, width: 1, color: Colors.white10),
          _buildSummaryItem('Balance', balance, theme.colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        Text(
          '₹${value.toStringAsFixed(0)}',
          style: GoogleFonts.outfit(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOverviewToggle(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'EXPENSE OVERVIEW',
            style: GoogleFonts.outfit(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, List<Transaction> transactions) {
    final expenses = transactions.where((t) => !t.isIncome).toList();
    if (expenses.isEmpty) return const SizedBox();

    return Column(
      children: [
        _buildChartCard(
          context,
          'EXPENSE BY CATEGORY',
          SizedBox(height: 300, child: WeekPieChart(transactions: expenses)),
        ),
        const SizedBox(height: 24),
        _buildChartCard(
          context,
          'EXPENSE BY DAY',
          SizedBox(height: 250, child: WeekBarChart(transactions: expenses)),
        ),
      ],
    );
  }

  Widget _buildChartCard(BuildContext context, String title, Widget chart) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4642),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: theme.colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Icon(
          Icons.donut_large_outlined,
          size: 80,
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
        const SizedBox(height: 16),
        Text(
          'No analysis for this month',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
