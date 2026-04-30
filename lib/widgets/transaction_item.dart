import 'package:expense_app/models/models.dart';
import 'package:expense_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/extensions/currency_extension.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key? key,
    required Transaction transaction,
    required Function deleteTransaction,
  })  : _transaction = transaction,
        _deleteTransaction = deleteTransaction,
        super(key: key);

  final Transaction _transaction;
  final Function _deleteTransaction;

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Entertainment':
        return Icons.movie;
      case 'Health':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(BuildContext context, String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Shopping':
        return Colors.pink;
      case 'Entertainment':
        return Colors.purple;
      case 'Health':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(_transaction.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.only(right: 20.0),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete_outline, color: Colors.white, size: 28),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _deleteTransaction(_transaction.id),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Delete Transaction?"),
              content: const Text("This action cannot be undone."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("DELETE"),
                ),
              ],
            ),
          );
        },
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(transaction: _transaction),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Category Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(context, _transaction.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    _getCategoryIcon(_transaction.category),
                    color: _getCategoryColor(context, _transaction.category),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _transaction.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _transaction.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Amount & Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '- ${_transaction.amount.parseCurrency()}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMd().format(_transaction.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


