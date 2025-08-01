import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final String folderId; // آیدی پوشه مرتبط

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isCompleted = false,
    this.folderId = "", // مقدار پیش‌فرض برای پشتیبانی از تسک‌های بدون پوشه
  });
}