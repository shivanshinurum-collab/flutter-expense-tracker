import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_app/blocs/app_blocs.dart';

class BudgetsPage extends StatelessWidget {
  const BudgetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Budgets'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, tState) {
          return BlocBuilder<BudgetCubit, double>(
            builder: (context, budget) {
              final totalSpent = tState.transactionsList.fold(0.0, (sum, item) => sum + item.amount);
              final percent = (totalSpent / budget).clamp(0.0, 1.0);
              final remaining = (budget - totalSpent).clamp(0.0, double.infinity);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildMainBudgetCard(context, budget, totalSpent, percent, remaining),
                    const SizedBox(height: 32),
                    _buildBudgetAdvice(context, percent),
                    const SizedBox(height: 32),
                    _buildCategoryBudgets(context, tState.transactionsList),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainBudgetCard(BuildContext context, double budget, double spent, double percent, double remaining) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 15,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percent > 0.9 ? Colors.redAccent : theme.colorScheme.primary,
                  ),
                ),
              ),
              Column(
                children: [
                  Text('${(percent * 100).toStringAsFixed(0)}%', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Used', style: theme.textTheme.labelLarge?.copyWith(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStat('Budget', '₹ ${budget.toStringAsFixed(0)}', Colors.grey),
              _buildSimpleStat('Remaining', '₹ ${remaining.toStringAsFixed(0)}', theme.colorScheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildBudgetAdvice(BuildContext context, double percent) {
    final theme = Theme.of(context);
    String title = "On Track";
    String advice = "You are doing great! Keep tracking your expenses.";
    IconData icon = Icons.check_circle_outline;
    Color color = Colors.green;

    if (percent > 0.8) {
      title = "Warning";
      advice = "You have used 80% of your budget. Be careful with new spendings.";
      icon = Icons.warning_amber_rounded;
      color = Colors.orange;
    }
    if (percent >= 1.0) {
      title = "Budget Exceeded";
      advice = "You have crossed your monthly limit. Review your spending habits.";
      icon = Icons.error_outline;
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(advice, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBudgets(BuildContext context, List<dynamic> transactions) {
    final theme = Theme.of(context);
    Map<String, double> catTotals = {};
    for (var t in transactions) {
      catTotals[t.category] = (catTotals[t.category] ?? 0) + t.amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category Spending', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...catTotals.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key),
                  Text('₹ ${e.value.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (e.value / 10000).clamp(0.0, 1.0), // Mock 10k cat budget
                borderRadius: BorderRadius.circular(10),
                backgroundColor: theme.colorScheme.surfaceVariant,
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}
