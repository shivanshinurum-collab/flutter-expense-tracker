import 'dart:io';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:expense_app/models/models.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTime _fromDate = DateTime(2026, 5, 1);
  DateTime _toDate = DateTime(2026, 5, 31);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final transController = Get.find<TransactionsController>();

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Export records',
          style: GoogleFonts.outfit(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Illustration
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade700, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'MyMoney',
                    style: GoogleFonts.outfit(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.radio_button_off, color: Colors.grey, size: 24),
                const Icon(Icons.arrow_forward, color: Colors.grey, size: 24),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.list_alt, color: Colors.grey, size: 32),
                      Text('.xlsx', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint('All records between a specified time range can be exported as a worksheet (Currently in .csv format).'),
                  const SizedBox(height: 16),
                  _buildBulletPoint('To export records, set the start time and end time of the interval below and tap EXPORT NOW.'),
                  const SizedBox(height: 16),
                  _buildBulletPoint('Note that, exported files(.csv) are not backup files and you cannot restore data from these files.'),
                ],
              ),
            ),
            const SizedBox(height: 48),
            // Date Selectors
            Text('From:', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            _buildDateSelector(_fromDate),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey, indent: 100, endIndent: 100),
            const SizedBox(height: 24),
            Text('To:', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            _buildDateSelector(_toDate),
            const SizedBox(height: 64),
            // Export Button
            OutlinedButton(
              onPressed: () => _exportData(transController.transactionsList),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'EXPORT NOW',
                style: GoogleFonts.outfit(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(List<Transaction> transactions) async {
    final filtered = transactions.where((t) {
      return t.date.isAfter(_fromDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(_toDate.add(const Duration(days: 1)));
    }).toList();

    if (filtered.isEmpty) {
      Get.snackbar(
        'Export',
        'No records found in this range.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black54,
        colorText: Colors.white,
      );
      return;
    }

    String csv = 'Date,Title,Category,Account,Type,Amount\n';
    for (var t in filtered) {
      csv += '${DateFormat('yyyy-MM-dd').format(t.date)},${t.title},${t.category},${t.account},${t.isIncome ? "Income" : "Expense"},${t.amount}\n';
    }

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/expenses_export.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(file.path)], text: 'MyMoney Export');
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('● ', style: TextStyle(color: Colors.white, fontSize: 14)),
        Expanded(child: Text(text, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16))),
      ],
    );
  }

  Widget _buildDateSelector(DateTime date) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        DateFormat('MMMM dd, yyyy').format(date).toUpperCase(),
        style: GoogleFonts.outfit(color: const Color(0xFFE8E5A2), fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
