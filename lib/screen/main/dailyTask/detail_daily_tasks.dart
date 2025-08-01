import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/taskController/addTask/add_task.dart';
import '../../../controller/taskController/task_controller.dart';
import '../../../util/color.dart';
import '../../../widget/title/title_custom.dart';

class DetailDailyTasksScreen extends StatefulWidget {
  const DetailDailyTasksScreen({Key? key}) : super(key: key);

  @override
  State<DetailDailyTasksScreen> createState() => _DetailDailyTasksScreenState();
}

class _DetailDailyTasksScreenState extends State<DetailDailyTasksScreen> {
  final TaskController taskController = Get.find<TaskController>();
  final FolderController folderController = Get.find<FolderController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // آیدی پوشه انتخاب شده (در صورت وجود)
  String selectedFolderId = "";

  @override
  void initState() {
    super.initState();

    // دریافت آیدی پوشه از آرگومان‌های صفحه (اگر موجود باشد)
    if (Get.arguments != null && Get.arguments['folderId'] != null) {
      selectedFolderId = Get.arguments['folderId'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TitleCustom(
          text: "افزودن تسک جدید",
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // عنوان تسک
              TitleCustom(
                text: "عنوان تسک",
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "عنوان تسک را وارد کنید",
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              SizedBox(height: 10),
              // توضیحات تسک
              TitleCustom(
                text: "توضیحات تسک",
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              TextField(
                controller: descriptionController,
                style: TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "توضیحات تسک را وارد کنید",
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
                // انتخاب پوشه
                TitleCustom(
                  text: "انتخاب پوشه",
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  child: Obx(() => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: folderController.folders.length + 1, // +1 برای گزینه "بدون پوشه"
                    itemBuilder: (context, index) {
                      // گزینه "بدون پوشه" در ابتدا
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFolderId = "";
                              });
                            },
                            child: Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration:BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: Colors.black54,
                                        border: Border(left: BorderSide(color: Colors.greenAccent,width: 3),
                                            top: BorderSide(color: Colors.greenAccent,width: 1),
                                            bottom: BorderSide(color: Colors.greenAccent,width: 1))
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add, color: Colors.white),
                                        SizedBox(width: 5),
                                        Text(
                                          "ساخت پوشه",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.toNamed("AddFolderScreen");
                                  },
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selectedFolderId.isEmpty
                                        ? Colors.greenAccent.withOpacity(0.4)
                                        : Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.folder_off, color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        "بدون پوشه",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // سایر پوشه‌ها
                        final folder = folderController.folders[index - 1];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFolderId = folder.title;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedFolderId == folder.title
                                    ? Colors.greenAccent.withOpacity(0.4)
                                    : Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.folder, color: Colors.amber),
                                  SizedBox(width: 5),
                                  Text(
                                    folder.title,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )),
                ),
              ],),
          ),


            // دکمه ذخیره
            Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    taskController.addTask(
                      titleController.text,
                      descriptionController.text,
                      folderId: selectedFolderId,
                    );
                    Get.back();
                    Get.snackbar(
                      "موفقیت",
                      "تسک با موفقیت اضافه شد",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      "خطا",
                      "لطفا عنوان تسک را وارد کنید",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "ذخیره تسک",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}