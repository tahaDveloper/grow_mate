import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../model/taskModel/task_model.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final Box<Task> taskBox = Hive.box<Task>('tasks');

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // بارگیری همه تسک‌ها
  void loadTasks() {
    tasks.assignAll(taskBox.values.toList());
  }

  // افزودن تسک جدید با امکان تعیین پوشه
  void addTask(String title, String description, {String folderId = ""}) {
    final id = const Uuid().v4();
    final task = Task(
      id: id,
      title: title,
      description: description,
      createdAt: DateTime.now(),
      folderId: folderId,
    );

    // ذخیره در Hive
    taskBox.put(id, task);

    // اضافه کردن به لیست
    tasks.add(task);
  }

  // حذف تسک با شناسه
  void deleteTask(String id) {
    // حذف از Hive
    taskBox.delete(id);

    // حذف از لیست
    tasks.removeWhere((task) => task.id == id);
  }

  // دریافت تسک‌های مربوط به یک پوشه خاص
  List<Task> getTasksByFolder(String folderId) {
    if (folderId.isEmpty) {
      return tasks;
    }
    return tasks.where((task) => task.folderId == folderId).toList();
  }

  // تغییر وضعیت تکمیل تسک
  void toggleTaskComplete(String id) {
    final task = taskBox.get(id);
    if (task != null) {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        createdAt: task.createdAt,
        isCompleted: !task.isCompleted,
        folderId: task.folderId,
      );

      // به‌روزرسانی در Hive
      taskBox.put(id, updatedTask);

      // به‌روزرسانی در لیست
      final index = tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    }
  }
}