import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Backup & Restore',
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.description_outlined, color: Colors.grey, size: 40),
                      Text('.mbak', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.swap_horiz, color: Colors.grey, size: 32),
                const SizedBox(width: 16),
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
                  _buildBulletPoint('A backup file contains all your records, categories, accounts & budgets (at the time of backup). Using this file, you can restore the saved data later in case your device is lost or you accidentally uninstall the app.'),
                  const SizedBox(height: 16),
                  _buildBulletPoint('Select a backup directory where you want MyMoney to create backup files and search for backup files to restore.'),
                  const SizedBox(height: 16),
                  _buildBulletPoint('To make a backup, press BACKUP NOW, and MyMoney will create a single backup file(.mbak) inside your chosen directory.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            _buildActionButton('BACKUP NOW', primaryColor),
            const SizedBox(height: 16),
            _buildActionButton('RESTORE', primaryColor),
            const SizedBox(height: 16),
            _buildActionButton('SELECT/CHANGE DIRECTORY', primaryColor),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'MyMoney will create new backup files in your selected directory.',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Widget _buildActionButton(String text, Color color) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1.5),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: GoogleFonts.outfit(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
