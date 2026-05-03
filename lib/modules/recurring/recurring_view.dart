import 'package:expense_app/modules/recurring/recurring_controller.dart';
import 'package:expense_app/models/recurring_transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecurringTransactionsScreen extends StatelessWidget {
  const RecurringTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recurringController = Get.find<RecurringController>();

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Recurring Transactions', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final recurringList = recurringController.recurringList;
        if (recurringList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.autorenew, size: 80, color: Colors.white10),
                const SizedBox(height: 16),
                const Text('No recurring transactions', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recurringList.length,
          itemBuilder: (context, index) {
            final item = recurringList[index];
            return _buildRecurringCard(context, item, theme, recurringController);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecurringDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecurringCard(BuildContext context, RecurringTransaction item, ThemeData theme, RecurringController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.isActive ? theme.colorScheme.primary.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (item.isIncome ? Colors.green : Colors.redAccent).withOpacity(0.1),
            child: Icon(
              item.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: item.isIncome ? Colors.green : Colors.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  '${item.frequency.name.toUpperCase()} • Next: ${DateFormat.yMMMd().format(item.nextOccurrence)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.amount.toStringAsFixed(0)}',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: item.isIncome ? Colors.green : Colors.redAccent,
                ),
              ),
              Switch(
                value: item.isActive,
                onChanged: (val) => controller.toggleActive(item),
                activeColor: theme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddRecurringDialog() {
    Get.snackbar(
      'Recurring',
      'Adding Recurring Transaction form coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }
}
