import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String iconPath;
  final bool isIncome;

  const Category({
    required this.id,
    required this.name,
    required this.iconPath,
    this.isIncome = false,
  });

  @override
  List<Object?> get props => [id, name, iconPath, isIncome];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'isIncome': isIncome ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconPath: map['iconPath'],
      isIncome: map['isIncome'] == 1,
    );
  }
}
