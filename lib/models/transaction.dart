import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final DateTime createdOn;
  final String imagePath;
  final String category;
  final String account;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.createdOn,
    required this.imagePath,
    required this.category,
    required this.account,
    this.isIncome = false,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      amount,
      date,
      createdOn,
      imagePath,
      category,
      account,
      isIncome,
    ];
  }

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    DateTime? createdOn,
    String? imagePath,
    String? category,
    String? account,
    bool? isIncome,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      createdOn: createdOn ?? this.createdOn,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      account: account ?? this.account,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount.toString(),
      'date': date.millisecondsSinceEpoch,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'category': category,
      'account': account,
      'isIncome': isIncome ? 1 : 0,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: double.tryParse(map['amount']) ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
      imagePath: map['imagePath'] ?? '',
      category: map['category'] ?? 'Others',
      account: map['account'] ?? 'Cash',
      isIncome: map['isIncome'] == 1,
    );
  }

  @override
  bool get stringify => true;
}


