import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../../../model/taskModel/addTask/add_task_model.dart';

class FolderController extends GetxController {
  // لیست پوشه‌ها به صورت قابل مشاهده
  RxList<FolderItem> folders = <FolderItem>[].obs;

  // پوشه انتخاب شده
  Rx<FolderItem?> selectedFolder = Rx<FolderItem?>(null);

  // نام باکس Hive
  static const String boxName = 'folders';

  @override
  void onInit() {
    super.onInit();
    loadFolders();
  }

  // بارگذاری پوشه‌ها از Hive
  Future<void> loadFolders() async {
    final box = await Hive.openBox<FolderItem>(boxName);
    folders.value = box.values.toList();
  }

  // ذخیره پوشه جدید
  Future<void> addFolder(String title) async {
    final box = await Hive.openBox<FolderItem>(boxName);

    // ایجاد رنگ تصادفی
    final List<Color> colors = [
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.amberAccent,
    ];
    final randomColor = colors[DateTime.now().millisecond % colors.length];

    // ایجاد پوشه جدید
    final newFolder = FolderItem(
      title: title,
      filesCount: 0,
      color: randomColor, id: '',
    );

    // ذخیره در Hive و به‌روزرسانی لیست قابل مشاهده
    await box.add(newFolder);
    folders.add(newFolder);
  }

  // تغییر نام پوشه
  Future<void> renameFolder(FolderItem folder, String newTitle) async {
    final box = await Hive.openBox<FolderItem>(boxName);

    // پیدا کردن ایندکس پوشه در باکس Hive
    final int? boxIndex = folder.key as int?;

    if (boxIndex != null) {
      // ایجاد پوشه با نام جدید
      final updatedFolder = FolderItem(
        title: newTitle,
        filesCount: folder.filesCount,
        color: folder.color, id: '',
      );

      // به‌روزرسانی در Hive
      await box.put(boxIndex, updatedFolder);

      // به‌روزرسانی در لیست قابل مشاهده
      final index = folders.indexOf(folder);
      if (index != -1) {
        folders[index] = updatedFolder;
        folders.refresh();

        // اگر پوشه انتخاب شده همان پوشه‌ای است که تغییر نام داده‌ایم
        if (selectedFolder.value == folder) {
          selectedFolder.value = updatedFolder;
        }
      }
    }
  }

  // حذف پوشه
  Future<void> deleteFolder(FolderItem folder) async {
    final box = await Hive.openBox<FolderItem>(boxName);

    // پیدا کردن ایندکس پوشه در باکس Hive
    final int? boxIndex = folder.key as int?;

    if (boxIndex != null) {
      // حذف از Hive
      await box.delete(boxIndex);

      // حذف از لیست قابل مشاهده
      folders.remove(folder);

      // اگر پوشه انتخاب شده همان پوشه‌ای است که حذف کرده‌ایم
      if (selectedFolder.value == folder) {
        selectedFolder.value = null;
      }
    }
  }

  // انتخاب یا لغو انتخاب پوشه
  void toggleFolderSelection(FolderItem folder) {
    if (selectedFolder.value == folder) {
      selectedFolder.value = null; // لغو انتخاب
    } else {
      selectedFolder.value = folder; // انتخاب جدید
    }
  }
}
