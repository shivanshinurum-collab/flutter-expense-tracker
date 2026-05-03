import 'package:flutter/material.dart';
import 'package:expense_app/models/models.dart';
import 'package:intl/intl.dart';

class InsightsPage extends StatelessWidget {
  final List<Transaction> transactions;

  const InsightsPage({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _calculateStats();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Financial Insights'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAdvisorHeader(context),
              const SizedBox(height: 32),
              
              Text('Spending Analysis', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTopCategoryCard(context, stats.topCategory, stats.topCategoryAmount),
              const SizedBox(height: 24),
              
              Text('Smart Suggestions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSuggestionCard(
                context,
                Icons.savings_outlined,
                'Potential Savings',
                stats.savingsAdvice,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildSuggestionCard(
                context,
                Icons.trending_up,
                'Investment Tip',
                stats.investmentAdvice,
                Colors.blue,
              ),
              const SizedBox(height: 32),
              
              _buildInvestmentGuide(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvisorHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Financial Advisor',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on your ${transactions.length} transactions this month.',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategoryCard(BuildContext context, String category, double amount) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Highest Spending', style: theme.textTheme.labelLarge),
              Text('₹ ${amount.toStringAsFixed(0)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 1.0,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          Text(
            'You spend the most on $category. Consider looking for alternatives to reduce this.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context, IconData icon, String title, String description, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentGuide(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Investment Guide', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildGuideItem(Icons.check_circle_outline, 'Emergency Fund: Save 6 months of expenses.'),
          _buildGuideItem(Icons.check_circle_outline, 'SIP: Start a Systematic Investment Plan today.'),
          _buildGuideItem(Icons.check_circle_outline, 'Insurance: Ensure you have health insurance.'),
        ],
      ),
    );
  }

  Widget _buildGuideItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  _InsightStats _calculateStats() {
    if (transactions.isEmpty) {
      return _InsightStats(
        topCategory: 'None',
        topCategoryAmount: 0,
        savingsAdvice: 'Add some transactions to see savings tips!',
        investmentAdvice: 'Consistent tracking is the first step to investing.',
      );
    }

    Map<String, double> catTotals = {};
    for (var t in transactions) {
      catTotals[t.category] = (catTotals[t.category] ?? 0) + t.amount;
    }

    var sortedEntries = catTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    var top = sortedEntries.first;
    
    String savings = "Reduce your ${top.key} expenses by 15% to save ₹ ${(top.value * 0.15).toStringAsFixed(0)} this month.";
    if (top.key == 'Food') savings = "Eating out less could save you a significant amount. Try meal prepping!";
    if (top.key == 'Shopping') savings = "Follow the 24-hour rule before buying non-essentials.";

    return _InsightStats(
      topCategory: top.key,
      topCategoryAmount: top.value,
      savingsAdvice: savings,
      investmentAdvice: "You have a stable spending pattern. Consider investing ₹ 2,000/month in an Index Fund.",
    );
  }
}

class _InsightStats {
  final String topCategory;
  final double topCategoryAmount;
  final String savingsAdvice;
  final String investmentAdvice;

  _InsightStats({
    required this.topCategory,
    required this.topCategoryAmount,
    required this.savingsAdvice,
    required this.investmentAdvice,
  });
}
