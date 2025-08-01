// مدل استراتژی مالی
import 'package:flutter/cupertino.dart';

class FinancialStrategy {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  bool isRecommended;

  FinancialStrategy({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isRecommended,
  });
}