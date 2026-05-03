import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_app/modules/other/views/views.dart';
import 'package:get/get.dart';
import 'package:expense_app/modules/settings/settings_controller.dart';

class MyMoneyStat {
  final String label;
  final double value;
  final Color color;

  MyMoneyStat({required this.label, required this.value, required this.color});
}

class MyMoneyHeader extends StatelessWidget {
  final List<MyMoneyStat> stats;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final bool showDateSelector;

  const MyMoneyHeader({
    Key? key,
    required this.stats,
    required this.selectedDate,
    required this.onDateChanged,
    this.showDateSelector = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // AppBar part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: primaryColor),
                  onPressed: () {
                    // Open the drawer of the main scaffold
                    Get.find<GlobalKey<ScaffoldState>>().currentState?.openDrawer();
                  },
                ),
                Text(
                  'MyMoney',
                  style: GoogleFonts.outfit(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Date Selector
          if (showDateSelector)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: primaryColor),
                        onPressed: () => onDateChanged(DateTime(selectedDate.year, selectedDate.month - 1)),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        DateFormat('MMMM, yyyy').format(selectedDate),
                        style: GoogleFonts.outfit(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.chevron_right, color: primaryColor),
                        onPressed: () => onDateChanged(DateTime(selectedDate.year, selectedDate.month + 1)),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.filter_list, color: primaryColor),
                      onPressed: () => _showDisplayOptionsDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          // Summary Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: stats.map((stat) => _buildStatItem(stat)).toList(),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildStatItem(MyMoneyStat stat) {
    final settingsController = Get.find<SettingsController>();
    return Column(
      children: [
        Text(
          stat.label,
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Obx(() => Text(
          '${settingsController.currencySymbol.value}${NumberFormat('#,##0.00').format(stat.value)}',
          style: GoogleFonts.outfit(
            color: stat.color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }

  void _showDisplayOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF4A4642),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Center(
          child: Text('Display options', style: TextStyle(color: Color(0xFFE8E5A2), fontWeight: FontWeight.bold)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionGroup('View mode:', ['DAILY', 'WEEKLY', 'MONTHLY', '3 MONTHS ★', '6 MONTHS ★', 'YEARLY ★'], 'MONTHLY'),
            const SizedBox(height: 16),
            _buildOptionGroup('Show total:', ['YES', 'NO'], 'YES'),
            const SizedBox(height: 16),
            _buildOptionGroup('Carry over:', ['ON', 'OFF'], 'OFF'),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'With Carry over enabled, monthly surplus will be added to the next month.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionGroup(String label, List<String> options, String selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFE8E5A2), fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...options.map((opt) {
          final isSelected = opt == selected;
          return Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Row(
              children: [
                if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16),
                if (isSelected) const SizedBox(width: 4),
                Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
