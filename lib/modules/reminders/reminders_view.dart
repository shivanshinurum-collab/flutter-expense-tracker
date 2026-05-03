import 'package:expense_app/modules/reminders/reminders_controller.dart';
import 'package:expense_app/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remindersController = Get.find<RemindersController>();

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Bill Reminders', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final reminders = remindersController.remindersList;
        if (reminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_none, size: 80, color: Colors.white10),
                const SizedBox(height: 16),
                const Text('No reminders set', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return _buildReminderCard(context, reminder, theme, remindersController);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        child: const Icon(Icons.add_alert),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context, Reminder reminder, ThemeData theme, RemindersController controller) {
    final isOverdue = !reminder.isPaid && reminder.dueDate.isBefore(DateTime.now());
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reminder.isPaid ? Colors.green.withOpacity(0.3) : (isOverdue ? Colors.red.withOpacity(0.5) : Colors.white10),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: reminder.isPaid,
            onChanged: (val) => controller.togglePaid(reminder),
            activeColor: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: reminder.isPaid ? TextDecoration.lineThrough : null,
                    color: reminder.isPaid ? Colors.grey : Colors.white,
                  ),
                ),
                Text(
                  'Due: ${DateFormat.yMMMd().format(reminder.dueDate)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.redAccent : Colors.grey,
                    fontSize: 12,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${reminder.amount.toStringAsFixed(0)}',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: reminder.isPaid ? Colors.grey : theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReminderDialog() {
    Get.snackbar(
      'Reminders',
      'Adding Bill Reminder form coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }
}
