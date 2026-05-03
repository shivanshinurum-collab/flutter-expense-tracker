import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('About MyMoney', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo & Version
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.account_balance_wallet_rounded, size: 80, color: primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                'MyMoney Finance Tracker',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Version 1.0.0 (Professional)',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),

              // App Description
              _buildSectionTitle('What is MyMoney?'),
              const SizedBox(height: 12),
              Text(
                'MyMoney is a powerful and intelligent personal finance management tool designed to help you take control of your financial life. Track expenses, manage multiple accounts, set monthly budgets, and gain deep insights through advanced analytical charts.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 40),

              // Developer Info Section
              const Divider(color: Colors.white10),
              const SizedBox(height: 32),
              _buildSectionTitle('Developed By'),
              const SizedBox(height: 24),
              
              // Profile Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white10,
                      child: Icon(Icons.person, size: 40, color: Color(0xFFE8E5A2)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Shivansh Kushwah',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE8E5A2),
                      ),
                    ),
                    const Text(
                      'Software Developer',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildContactRow(Icons.email_outlined, 's.kushwah9898@gmail.com', () {
                      launchUrl(Uri.parse('mailto:s.kushwah9898@gmail.com'));
                    }),
                    const SizedBox(height: 12),
                    _buildContactRow(Icons.phone_android_outlined, '+91 98268 71510', () {
                      launchUrl(Uri.parse('tel:+919826871510'));
                    }),
                    const SizedBox(height: 12),
                    _buildContactRow(Icons.location_on_outlined, 'Indore, MP, India', () {
                      launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=Indore'));
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              // Footer
              Text(
                'Made with ❤️ in India',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: const Color(0xFFE8E5A2),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey, size: 18),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
