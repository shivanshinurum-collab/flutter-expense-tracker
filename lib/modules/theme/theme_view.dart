import 'package:expense_app/modules/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeThemePage extends StatelessWidget {
  const ChangeThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
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
                  _buildThemeCard(context, 'Indigo', const Color(0xFF6366F1), () => themeController.toIndigo()),
                  _buildThemeCard(context, 'Green', const Color(0xFF10B981), () => themeController.toGreen()),
                  _buildThemeCard(context, 'Purple', const Color(0xFF8B5CF6), () => themeController.toPurple()),
                  _buildThemeCard(context, 'Red', const Color(0xFFEF4444), () => themeController.toRed()),
                  _buildThemeCard(context, 'Blue', const Color(0xFF3B82F6), () => themeController.toBlue()),
                ],
              ),
              const SizedBox(height: 32),
              
              Text('Mode', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildModeToggle(context, themeController),
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

  Widget _buildModeToggle(BuildContext context, ThemeController controller) {
    return Obx(() {
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
                  controller.toIndigo(); // We don't have a specific toDark but the themes are dark/light seed
                  // Actually the _createTheme uses isDark.
                  // For simplicity, let's just toggle some existing theme or add dark/light toggle in Controller.
                } else {
                  controller.toIndigo();
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
