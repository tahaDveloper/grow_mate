import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';


@HiveType(typeId: 4)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  @HiveField(5)
  final TransactionType type;

  @HiveField(6)
  final String note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    required this.note,
  });

  factory TransactionModel.create({
    required String title,
    required int amount,
    required DateTime date,
    required Category category,
    required TransactionType type,
    required String note,
  }) {
    return TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      category: category,
      type: type,
      note: note,
    );
  }
}

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense
}

@HiveType(typeId: 3)
enum Category {
  // درآمدها
  @HiveField(0)
  salary,
  @HiveField(1)
  business,
  @HiveField(2)
  investment,
  @HiveField(3)
  gift,
  @HiveField(4)
  other_income,

  // هزینه‌ها
  @HiveField(5)
  food,
  @HiveField(6)
  shopping,
  @HiveField(7)
  transport,
  @HiveField(8)
  bills,
  @HiveField(9)
  entertainment,
  @HiveField(10)
  health,
  @HiveField(11)
  education,
  @HiveField(12)
  other_expense
}

extension CategoryExtension on Category {
  String get persianName {
    switch (this) {
      case Category.salary: return 'حقوق';
      case Category.business: return 'کسب و کار';
      case Category.investment: return 'سرمایه‌گذاری';
      case Category.gift: return 'هدیه';
      case Category.other_income: return 'سایر درآمدها';
      case Category.food: return 'غذا';
      case Category.shopping: return 'خرید';
      case Category.transport: return 'حمل و نقل';
      case Category.bills: return 'قبوض';
      case Category.entertainment: return 'تفریح';
      case Category.health: return 'سلامتی';
      case Category.education: return 'آموزش';
      case Category.other_expense: return 'سایر هزینه‌ها';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.salary: return Icons.account_balance_wallet;
      case Category.business: return Icons.business_center;
      case Category.investment: return Icons.trending_up;
      case Category.gift: return Icons.card_giftcard;
      case Category.other_income: return Icons.add_circle;
      case Category.food: return Icons.restaurant;
      case Category.shopping: return Icons.shopping_cart;
      case Category.transport: return Icons.directions_car;
      case Category.bills: return Icons.receipt;
      case Category.entertainment: return Icons.movie;
      case Category.health: return Icons.favorite;
      case Category.education: return Icons.school;
      case Category.other_expense: return Icons.remove_circle;
    }
  }

  Color get color {
    switch (this) {
      case Category.salary: return const Color(0xFF43E97B);
      case Category.business: return const Color(0xFF38B9FF);
      case Category.investment: return const Color(0xFFB548C6);
      case Category.gift: return const Color(0xFFFF8C00);
      case Category.other_income: return const Color(0xFF6C63FF);
      case Category.food: return const Color(0xFFFF6584);
      case Category.shopping: return const Color(0xFFF953C6);
      case Category.transport: return const Color(0xFFFFB480);
      case Category.bills: return const Color(0xFFB91D73);
      case Category.entertainment: return const Color(0xFFE55D87);
      case Category.health: return const Color(0xFF19B5FE);
      case Category.education: return const Color(0xFF3F5EFB);
      case Category.other_expense: return const Color(0xFF6C63FF);
    }
  }

  bool get isIncome {
    return this == Category.salary ||
        this == Category.business ||
        this == Category.investment ||
        this == Category.gift ||
        this == Category.other_income;
  }
}