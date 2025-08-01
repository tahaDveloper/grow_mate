import 'dart:ui';

import 'package:hive/hive.dart';
part 'add_task_model.g.dart'; // این فایل با دستور build_runner ساخته میشه

@HiveType(typeId: 0)
class FolderItem extends HiveObject {
  @HiveField(0)
  String id ;

  @HiveField(1)
  String title;

  @HiveField(2)
  int filesCount;

  @HiveField(3)
  int colorValue; // ذخیره مقدار رنگ به جای خود رنگ

  FolderItem({
    required this.id,
    required this.title,
    required this.filesCount,
    required Color color,
  }) : colorValue = color.value;

  // متد کمکی برای تبدیل مقدار رنگ به شیء Color
  Color get color => Color(colorValue);


  @override
  int get hashCode => title.hashCode ^ filesCount.hashCode ^ colorValue.hashCode;
}