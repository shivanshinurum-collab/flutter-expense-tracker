import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/repositories/repositories.dart';
import 'package:expense_app/screens/screens.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => NewTransaction.add(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  bool _showBarChart = true;

  double _calculateTotalSpending(List<Transaction> transactions) {
    return transactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<TransactionsBloc, TransactionsState>(
        listener: (context, state) {
          if (state.status == TStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: Theme.of(context).colorScheme.error,
            ));
          }
        },
        builder: (context, state) {
          if (state.status == TStatus.initial ||
              state.status == TStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final totalSpending = _calculateTotalSpending(state.transactionsList);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'My Expenses',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider<SearchCubit>(
                            create: (context) => SearchCubit(
                              transactionsRepository:
                                  context.read<TransactionsRepository>(),
                            )..loadAll(),
                            child: SearchPage(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceCard(context, totalSpending),
                      const SizedBox(height: 16),
                      _buildAdvisorBanner(context, state.transactionsList),
                      const SizedBox(height: 24),
                      
                      // Chart Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Analytics',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showBarChart = !_showBarChart;
                              });
                            },
                            icon: Icon(_showBarChart ? Icons.pie_chart : Icons.bar_chart),
                            label: Text(_showBarChart ? 'Pie View' : 'Bar View'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Chart Card
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: state.transactionsList.isEmpty
                          ? const Center(child: Text('Add transactions to see analytics'))
                          : _showBarChart
                              ? WeekBarChart(transactions: state.transactionsList)
                              : WeekPieChart(transactions: state.transactionsList),
                      ),
                      const SizedBox(height: 24),
                      
                      // Recent Transactions Header
                      Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              state.transactionsList.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(context),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final reversedList = state.transactionsList.reversed.toList();
                            return TransactionItem(
                              transaction: reversedList[index],
                              deleteTransaction: (String id) {
                                context.read<TransactionsBloc>().add(
                                  RemoveTransaction(transactionID: id),
                                );
                              },
                            );
                          },
                          childCount: state.transactionsList.length,
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startAddNewTransaction(context),
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double amount) {
    return BlocBuilder<BudgetCubit, double>(
      builder: (context, budget) {
        final percent = (amount / budget).clamp(0.0, 1.0);
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Spending',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    'Budget: ₹ ${budget.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '₹ ${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percent > 0.9 ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
              _buildMiniStat(Icons.arrow_upward, 'Spent', '₹ ${amount.toStringAsFixed(0)}'),
              const SizedBox(width: 40),
              _buildMiniStat(Icons.arrow_downward, 'Limit', '₹ ${budget.toStringAsFixed(0)}'),
            ],
          ),
        ],
      ),
    );
  },
);
}

  Widget _buildMiniStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 100,
            color: Theme
                .of(context)
                .colorScheme
                .primary
                .withOpacity(0.2),
          ),
          const SizedBox(height: 20),
          Text(
            'No Transactions Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Tap the button below to add your first expense'),
        ],
      ),
    );
  }

  Widget _buildAdvisorBanner(BuildContext context, List<Transaction> transactions) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => InsightsPage(transactions: transactions))),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.tertiaryContainer, theme.colorScheme.secondaryContainer.withOpacity(0.5)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Get Smart Insights', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Tap to see your financial health', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}


