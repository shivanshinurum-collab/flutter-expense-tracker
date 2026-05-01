import 'package:expense_app/blocs/app_blocs.dart';
import 'package:intl/intl.dart';
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

  double _calculateTotalExpense(List<Transaction> transactions) {
    return transactions.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
  }

  double _calculateTotalIncome(List<Transaction> transactions) {
    return transactions.where((t) => t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
  }

  Map<String, List<Transaction>> _groupTransactions(List<Transaction> transactions) {
    Map<String, List<Transaction>> grouped = {};
    for (var t in transactions) {
      String dateKey = DateFormat('yyyy-MM-dd').format(t.date);
      if (grouped[dateKey] == null) grouped[dateKey] = [];
      grouped[dateKey]!.add(t);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.status == TStatus.initial || state.status == TStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final totalExpense = _calculateTotalExpense(state.transactionsList);
          final totalIncome = _calculateTotalIncome(state.transactionsList);
          final balance = totalIncome - totalExpense;
          final groupedTransactions = _groupTransactions(state.transactionsList.reversed.toList());

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: theme.colorScheme.primary,
                expandedHeight: 220.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildHeaderStat('Income', totalIncome, Colors.greenAccent),
                            _buildHeaderStat('Expense', totalExpense, Colors.redAccent),
                            _buildHeaderStat('Total', balance, Colors.white),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Search Bar
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            onChanged: (val) {
                              // I'll integrate real search logic later or just use navigation
                            },
                            readOnly: true,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider<SearchCubit>(
                              create: (context) => SearchCubit(transactionsRepository: context.read<TransactionsRepository>())..loadAll(),
                              child: SearchPage(),
                            ))),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search transactions...',
                              hintStyle: TextStyle(color: Colors.white60),
                              prefixIcon: Icon(Icons.search, color: Colors.white60),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    DateFormat('MMMM yyyy').format(DateTime.now()),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildBalanceCard(context, totalExpense), // This still shows budget progress
                  ),
                ),
              ),
              if (state.transactionsList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                )
              else
                ...groupedTransactions.entries.map((entry) {
                  final date = DateTime.parse(entry.key);
                  final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == entry.key;
                  final dayExpense = entry.value.where((t) => !t.isIncome).fold(0.0, (sum, item) => sum + item.amount);
                  final dayIncome = entry.value.where((t) => t.isIncome).fold(0.0, (sum, item) => sum + item.amount);

                  return SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isToday ? 'Today' : DateFormat('EEEE, MMM dd').format(date),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  if (dayIncome > 0)
                                    Text(
                                      '+₹ ${dayIncome.toStringAsFixed(0)} ',
                                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  Text(
                                    '₹ ${dayExpense.toStringAsFixed(0)}',
                                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => TransactionItem(
                              transaction: entry.value[index],
                              deleteTransaction: (id) => context.read<TransactionsBloc>().add(RemoveTransaction(transactionID: id)),
                            ),
                            childCount: entry.value.length,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeaderStat(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          '₹ ${value.abs().toStringAsFixed(0)}',
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
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


