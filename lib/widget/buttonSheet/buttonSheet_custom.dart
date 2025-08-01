import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_mate/util/color.dart';
import 'package:hive/hive.dart';
import '../../controller/bottomSheet/bottonSheet_controller.dart';
import '../../controller/taskController/task_controller.dart';
import '../../model/taskModel/task_model.dart';
import '../../screen/main/dailyTask/daily_task.dart';
import '../button/custom_butten.dart';
import '../title/title_custom.dart';

// class CustomBottomSheet extends StatelessWidget {
//   CustomBottomSheet({super.key});
//   final BottomSheetController controller = Get.put(BottomSheetController());
//
//   final List<String> titles = ['کار', 'خانه', 'ورزش', 'استراحت','کار','کار', ];
//
//
//   final TaskController taskController = Get.put(TaskController());
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       padding: const EdgeInsets.all(20),
//       height: Get.height * 0.6,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Center(child: Icon(Icons.drag_handle, color: Colors.grey)),
//           const SizedBox(height: 20),
//           TitleCustom(
//               text: 'انتخاب دسته بندی',
//               color: buttonColor,
//               fontSize: 30,
//               fontWeight: FontWeight.w800),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: titles.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: Obx(() => Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Checkbox(
//                         value: controller.selectIndex.value == index,
//                         onChanged: (_) =>
//                             controller.toggleCheck(index),
//                         activeColor: buttonColor,
//                       ),
//                       TitleCustom(
//                         text: titles[index],
//                         color: Colors.white54,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ],
//                   )),
//                 );
//               },
//             ),
//           ),
//           CustomElevatedButton(
//             text: 'ذخیره',
//             onPressed: () {
//
//               final selected = titles;
//
//               final String title = titleController.text;
//               final String description = descriptionController.text;
//
//               if (controller.selectIndex.value == null){
//                 Get.snackbar("صبر کن", "مقادیر خالی است",backgroundColor: Colors.red);
//               }
//               else if (selected != -1) {
//
//                 final newTask = Task(
//                     title: title,
//                     description: description,
//                     isCompleted: false,
//                     category: "");
//
//                 Hive.box<Task>("tasks").add(newTask); // ذخیره در دیتابیس
//
//                 print("${newTask}");
//
//                 Get.toNamed("DashboardPage");
//
//                 Get.snackbar("درود", "با موفقیت وارد شد",backgroundColor: Colors.greenAccent,);
//
//                 controller.selectIndex.value = -1;
//               }
//
//               },
//             color: buttonColor,
//             paddingVertical: 10,
//           )
//
//
//         ],
//       ),
//     );
//   }
// }
