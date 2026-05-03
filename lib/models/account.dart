import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String name;
  final double balance;
  final String iconPath;

  const Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.iconPath,
  });

  @override
  List<Object?> get props => [id, name, balance, iconPath];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'iconPath': iconPath,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      balance: (map['balance'] as num).toDouble(),
      iconPath: map['iconPath'],
    );
  }
}
