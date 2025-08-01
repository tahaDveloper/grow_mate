import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:grow_mate/model/taskModel/task_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../controller/taskController/addTask/add_task.dart';
import '../../../controller/taskController/task_controller.dart';
import '../../../model/taskModel/addTask/add_task_model.dart';
import '../../../util/color.dart';
import '../../../widget/button/custom_butten.dart';
import '../../../widget/paint/holePaint.dart';
import '../../../widget/title/title_custom.dart';

class DailyTasksScreen extends StatefulWidget {
  const DailyTasksScreen({super.key});

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  final TaskController taskController = Get.put(TaskController());
  final FolderController folderController = Get.put(FolderController());
  final Box<Task> taskBox = Hive.box<Task>("tasks");

  // Observable state for selected folder
  final RxString selectedFolderId = "".obs;


  Future<void> dialog(task) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 15,
          backgroundColor: const Color(0xFF1A1A40),
          title: const Text(
            '✨ درود ✨',
            style: TextStyle(
              fontFamily: 'Shabnam',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              shadows: [
                Shadow(color: Colors.purpleAccent, blurRadius: 10),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "آیا مطمئن هستید که می‌خواهید این پوشه  را برای همیشه به سرزمین فراموشی بفرستید؟ 🧙‍♂️",
            style: TextStyle(
              fontFamily: 'Shabnam',
              fontSize: 18,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'لغو ❌',
                style: TextStyle(
                  fontFamily: 'Shabnam',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'حذف 🗑️',
                style: TextStyle(
                  fontFamily: 'Shabnam',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                taskController.deleteTask(task.id);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    // Listen to changes in the selectedFolderId to force refresh
    ever(selectedFolderId, (_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/image/ChatGPT Image Apr 30, 2025, 05_05_19 PM.png",
                width: Get.width,
                fit: BoxFit.cover,
              ),
            ),

            // Header section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          TitleCustom(
                            text: 'Goal                   ',
                            color: Colors.amber,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                          TitleCustom(
                            text: '    and                 ',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                          TitleCustom(
                            text: '         Task          ',
                            color: Colors.green,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom content section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: Get.height * 0.4,
                child: Stack(
                  children: [
                    // Custom background shape
                    CustomPaint(
                      size: Size(Get.width, Get.height * 0.5),
                      painter: BNBCustomPainter(),
                    ),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Title and add goal button
                            _buildInputField(),

                            // Folders list
                            _buildFoldersList(),

                            // Tasks section
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Divider(height: 10, color: Colors.white),
                                  _buildTasksSection(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Folders list section
  Widget _buildFoldersList() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            child: Obx(() {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: folderController.folders.length + 1, // +1 for "All" option
                itemBuilder: (context, index) {
                  // "All" option at the beginning
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Select all tasks (no filter)
                          selectedFolderId.value = "";
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: selectedFolderId.value == ""
                                ? Colors.greenAccent.withOpacity(0.4)
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.folder_open, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                "همه",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Show other folders
                    final folder = folderController.folders[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Select this folder
                          selectedFolderId.value = folder.title;
                          print("Selected folder: ${folder.title}"); // Debug print
                        },
                        child: _buildFolderItem(folder),
                      ),
                    );
                  }
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  // Individual folder item widget
  Widget _buildFolderItem(FolderItem folder) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selectedFolderId.value == folder.title
            ? Colors.greenAccent.withOpacity(0.4)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder, color: Colors.amber),
          const SizedBox(width: 5),
          Text(
            folder.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Tasks section with proper Hive and GetX integration
  Widget _buildTasksSection() {
    // Return the ValueListenableBuilder directly to ensure UI updates with Hive changes
    return ValueListenableBuilder<Box<Task>>(
      valueListenable: taskBox.listenable(),
      builder: (context, box, _) {
        // Filter tasks based on selected folder
        List<Task> filteredTasks = [];

        // Debug print
        print("Current folder ID: ${selectedFolderId.value}");
        print("All tasks count: ${box.values.length}");

        if (selectedFolderId.value.isEmpty) {
          // If no folder is selected, show all tasks
          filteredTasks = box.values.toList();
        } else {
          // Otherwise, show only tasks from the selected folder
          filteredTasks = box.values
              .where((task) => task.folderId == selectedFolderId.value)
              .toList();
        }

        print("Filtered tasks count: ${filteredTasks.length}");

        // Show a message if no tasks are found
        if (filteredTasks.isEmpty) {
          return Center(
            child: Container(
              height: Get.height * 0.1,
              alignment: Alignment.center,
              child: TitleCustom(
                text: selectedFolderId.value.isEmpty
                    ? "هیچ تسکی وجود ندارد"
                    : "هیچ تسکی در این پوشه وجود ندارد",
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }

        // Display tasks in a horizontal list
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filteredTasks.map((task) {
              return _buildTaskCard(task);
            }).toList(),
          ),
        );
      },
    );
  }

  // Individual task card widget
  Widget _buildTaskCard(Task task) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        height: Get.height * 0.15,
        width: Get.width * 0.35,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    onPressed: () {
                      dialog(task);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleCustom(
                      text: task.title.length > 10
                          ? "${task.title.substring(0, 10)}"
                          : task.title,
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    const SizedBox(height: 10),
                    TitleCustom(
                      text: task.description.length > 50
                          ? "${task.description.substring(0, 40)}..."
                          : task.description,
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Title and button section
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleCustom(
            text: "اضافه کردن هدف ",
            color: AppTheme.buttonColor,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed("/DetailDailyTasksScreen");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }
}