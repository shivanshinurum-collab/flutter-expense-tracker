import 'package:expense_app/widgets/details_title.dart';
import 'package:flutter/material.dart';

import 'package:expense_app/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Developer Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, size: 60, color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Shivansh Kushwah',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Flutter Developer',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              
              // Info Cards
              _buildInfoCard(
                context,
                Icons.school,
                'Education',
                'Btech CST 3rd Year\nSage University Indore',
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                Icons.assignment,
                'Project',
                'Minor Project\nExpense Tracker with Smart Insights',
              ),
              const SizedBox(height: 32),
              
              // About Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Passionate CS student specializing in mobile app development. This project aims to provide users with a clean, modern, and intelligent way to track their daily expenses and gain financial insights.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Contact Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {}, // Placeholder for contact
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Get in Touch'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


