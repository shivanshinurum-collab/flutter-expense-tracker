import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:expense_app/blocs/app_blocs.dart';

class ChangeThemePage extends StatelessWidget {
  const ChangeThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Color Theme', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildThemeCard(context, 'Indigo', const Color(0xFF6366F1), () => themeCubit.toIndigo()),
                  _buildThemeCard(context, 'Green', const Color(0xFF10B981), () => themeCubit.toGreen()),
                  _buildThemeCard(context, 'Purple', const Color(0xFF8B5CF6), () => themeCubit.toPurple()),
                  _buildThemeCard(context, 'Red', const Color(0xFFEF4444), () => themeCubit.toRed()),
                  _buildThemeCard(context, 'Blue', const Color(0xFF3B82F6), () => themeCubit.toBlue()),
                ],
              ),
              const SizedBox(height: 32),
              
              Text('Mode', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildModeToggle(context, themeCubit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, String name, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(backgroundColor: color, radius: 15),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle(BuildContext context, ThemeCubit cubit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Switch(
            value: isDark,
            onChanged: (val) {
              if (val) {
                cubit.toDark();
              } else {
                cubit.toIndigo(); // Default light
              }
            },
          ),
        ],
      ),
    );
  }
}


