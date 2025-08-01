// Models for Hive storage
import 'package:hive/hive.dart';

@HiveType(typeId: 8)
class Goal extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String category;

  Goal({
    required this.title,
    required this.description,
    required this.createdAt,
    this.isCompleted = false,
    this.category = 'Personal',
  });
}