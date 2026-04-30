import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/screens/screens.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Preferences', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                Icons.color_lens_outlined,
                'Appearance',
                'Change theme colors and mode',
                () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangeThemePage())),
              ),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                Icons.account_balance_wallet_outlined,
                'Monthly Budget',
                'Set your spending limit',
                () => _showBudgetDialog(context),
              ),
              const SizedBox(height: 16),
              
              Text('Personal Finance', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                Icons.auto_awesome_outlined,
                'Financial Advisor',
                'Get AI-powered spending insights',
                () {
                  final tBloc = context.read<TransactionsBloc>();
                  if (tBloc.state.status == TStatus.loaded) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => InsightsPage(transactions: tBloc.state.transactionsList),
                    ));
                  }
                },
              ),
              const SizedBox(height: 32),
              
              Text('Support & Info', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                Icons.person_outline,
                'Developer Contact',
                'About Shivansh Kushwah',
                () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DeveloperPage())),
              ),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                Icons.info_outline,
                'About App',
                'Version 2.0.0',
                () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutPage())),
              ),
              const SizedBox(height: 16),
              _buildSettingsTile(
                context,
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                'Read our terms and conditions',
                () {}, // Placeholder for URL launch
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context) {
    final controller = TextEditingController(text: context.read<BudgetCubit>().state.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '₹ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final budget = double.tryParse(controller.text);
              if (budget != null) {
                context.read<BudgetCubit>().updateBudget(budget);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}


