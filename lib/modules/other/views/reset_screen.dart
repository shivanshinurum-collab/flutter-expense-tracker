import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({Key? key}) : super(key: key);

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
          'Delete & Reset',
          style: GoogleFonts.outfit(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          _buildResetTile('Delete all records', 'Delete all records, but keeping current accounts, categories and budgets'),
          _buildResetTile('Delete all', 'Delete everything including records, accounts, categories and budgets'),
          _buildResetTile('Reset all', 'Resetting the app to its initial state, deleting current records, accounts categories, and budgets'),
        ],
      ),
    );
  }

  Widget _buildResetTile(String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(title, style: GoogleFonts.outfit(color: const Color(0xFFE8E5A2), fontSize: 18, fontWeight: FontWeight.bold)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ),
      onTap: () {},
    );
  }
}
