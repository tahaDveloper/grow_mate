import 'package:hive/hive.dart';

@HiveType(typeId: 10)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String mood;

  JournalEntry({
    required this.title,
    required this.content,
    required this.createdAt,
    this.mood = '😊',
  });
}