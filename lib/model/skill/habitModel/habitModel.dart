import 'package:hive/hive.dart';

@HiveType(typeId: 9)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  List<DateTime> completedDates;

  @HiveField(3)
  String icon;

  Habit({
    required this.name,
    required this.description,
    required this.completedDates,
    this.icon = '⭐',
  });
}