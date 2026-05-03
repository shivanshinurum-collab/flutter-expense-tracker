import 'package:equatable/equatable.dart';

enum RecurringFrequency { daily, weekly, monthly, yearly }

class RecurringTransaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String account;
  final bool isIncome;
  final RecurringFrequency frequency;
  final DateTime nextOccurrence;
  final bool isActive;

  const RecurringTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.account,
    required this.isIncome,
    required this.frequency,
    required this.nextOccurrence,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, title, amount, category, account, isIncome, frequency, nextOccurrence, isActive];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'account': account,
      'isIncome': isIncome ? 1 : 0,
      'frequency': frequency.index,
      'nextOccurrence': nextOccurrence.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory RecurringTransaction.fromMap(Map<String, dynamic> map) {
    return RecurringTransaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      account: map['account'],
      isIncome: map['isIncome'] == 1,
      frequency: RecurringFrequency.values[map['frequency']],
      nextOccurrence: DateTime.parse(map['nextOccurrence']),
      isActive: map['isActive'] == 1,
    );
  }
}
