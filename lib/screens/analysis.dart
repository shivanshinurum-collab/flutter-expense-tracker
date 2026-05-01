import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/widgets/widgets.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Analysis'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.transactionsList.isEmpty) {
            return const Center(child: Text('No data to analyze. Add some expenses first!'));
          }

          final totalExpense = state.transactionsList.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
          final totalIncome = state.transactionsList.where((t) => t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
          final balance = totalIncome - totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCashFlowSummary(context, totalIncome, totalExpense, balance),
                const SizedBox(height: 32),
                
                Text('Category Breakdown', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: WeekPieChart(transactions: state.transactionsList.where((t) => !t.isIncome).toList()),
                ),
                const SizedBox(height: 32),
                
                Text('Weekly Spending', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: WeekBarChart(transactions: state.transactionsList.where((t) => !t.isIncome).toList()),
                ),
                const SizedBox(height: 32),
                
                _buildSummaryStats(context, state.transactionsList),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCashFlowSummary(BuildContext context, double income, double expense, double balance) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Text('Net Balance', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
          const SizedBox(height: 8),
          Text('₹ ${balance.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFlowItem('Income', income, Colors.greenAccent),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildFlowItem('Expense', expense, Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlowItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text('₹ ${value.toStringAsFixed(0)}', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryStats(BuildContext context, List<dynamic> transactions) {
    final theme = Theme.of(context);
    double totalExp = transactions.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
    double totalInc = transactions.where((t) => t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
    int count = transactions.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          _buildStatRow('Total Records', count.toString()),
          const Divider(height: 32),
          _buildStatRow('Total Income', '₹ ${totalInc.toStringAsFixed(0)}'),
          const Divider(height: 32),
          _buildStatRow('Total Expense', '₹ ${totalExp.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
