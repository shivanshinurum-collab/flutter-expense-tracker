import 'dart:io';
import 'package:expense_app/extensions/extensions.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatelessWidget {
  final Transaction _transaction;
  const DetailsPage({Key? key, required Transaction transaction})
      : _transaction = transaction,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                builder: (_) => NewTransaction.edit(transaction: _transaction),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
              // The BLoC listener in Home will handle updates, 
              // but for this page we might need to pop or listen to BLoC.
              // For simplicity in this demo, we'll just pop.
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(_transaction.category),
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _transaction.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹ ${_transaction.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile(context, Icons.category_outlined, 'Category', _transaction.category),
                  const SizedBox(height: 20),
                  _buildInfoTile(context, Icons.calendar_today_outlined, 'Date', DateFormat.yMMMMEEEEd().format(_transaction.date)),
                  const SizedBox(height: 20),
                  _buildInfoTile(context, Icons.access_time, 'Added On', DateFormat.yMMMd().add_jm().format(_transaction.createdOn)),
                  
                  if (_transaction.imagePath.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text('Receipt Attachment', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(
                        File(_transaction.imagePath),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: theme.colorScheme.surfaceVariant,
                          child: const Icon(Icons.broken_image_outlined, size: 48),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Shopping': return Icons.shopping_bag;
      case 'Entertainment': return Icons.movie;
      case 'Health': return Icons.medical_services;
      default: return Icons.category;
    }
  }
}


