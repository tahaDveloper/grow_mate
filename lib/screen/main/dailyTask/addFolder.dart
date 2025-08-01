import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/taskController/addTask/add_task.dart';
import '../../../model/taskModel/addTask/add_task_model.dart';


class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({super.key});

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final TextEditingController folderNameController = TextEditingController();
  final FolderController folderController = Get.put(FolderController());

  @override
  void dispose() {
    folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: Text(""),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "مدیریت فایل ها",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          RotatedBox(
            quarterTurns: 2,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
              onPressed: () {
                Get.back();
              },
            ),
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "پوشه های اخیر",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: folderController.folders.length + 1, // +1 for the add folder button
                  itemBuilder: (context, index) {
                    if (index == folderController.folders.length) {
                      return _buildAddFolderButton();
                    }
                    return _buildFolderItem(folderController.folders[index]);
                  },
                )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, size: 32),
        onPressed: () => _showAddFolderBottomSheet(),
      ),
    );
  }

  Widget _buildFolderItem(FolderItem folder) {
    return Obx(() {
      final bool isSelected = folderController.selectedFolder.value == folder;

      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : folder.color.withOpacity(0.5),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: InkWell(
          onTap: () {
            folderController.toggleFolderSelection(folder);
          },
          onLongPress: () {
            folderController.selectedFolder.value = folder;
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildFolderOptionsSheet(folder),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      isSelected ? Icons.folder_open : Icons.folder_rounded,
                      color: folder.color,
                      size: 40,
                    ),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white54,
                      ),
                      color: const Color(0xFF252525),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'rename',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "تغییر نام",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text(
                                "حذف",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'rename') {
                          _renameFolder(folder);
                        } else if (value == 'delete') {
                          _deleteFolder(folder);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  folder.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${folder.filesCount}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAddFolderButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white24,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () => _showAddFolderBottomSheet(),
        borderRadius: BorderRadius.circular(16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Colors.greenAccent,
              size: 40,
            ),
            SizedBox(height: 12),
            Text(
              "ایجاد پوشه جدید",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نمایش گزینه‌های پوشه
  Widget _buildFolderOptionsSheet(FolderItem folder) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              folder.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${folder.filesCount} فایل",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionButton(
              icon: Icons.edit,
              text: "تغییر نام",
              color: Colors.blueAccent,
              onTap: () {
                Navigator.pop(context);
                _renameFolder(folder);
              },
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              icon: Icons.delete_forever,
              text: "حذف پوشه",
              color: Colors.redAccent,
              onTap: () {
                Get.back(result: context);
                _deleteFolder(folder);
              },
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              icon: Icons.close,
              text: "بستن",
              color: Colors.white54,
              onTap: () => Get.back(result: context),
            ),
          ],
        ),
      ),
    );
  }

  // دکمه گزینه
  Widget _buildOptionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(color: color, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _renameFolder(FolderItem folder) {
    folderNameController.text = folder.title;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "تغییر نام پوشه",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: folderNameController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "نام جدید پوشه",
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.edit, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (folderNameController.text.isNotEmpty) {
                              final oldName = folder.title;
                              await folderController.renameFolder(folder, folderNameController.text);
                              Get.back();

                              // نمایش پیام موفقیت
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text("نام پوشه از «$oldName» به «${folderNameController.text}» تغییر یافت"),
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "ذخیره تغییرات",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "انصراف",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteFolder(FolderItem folder) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "حذف پوشه",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "آیا از حذف پوشه «${folder.title}» اطمینان دارید؟\nاین عملیات غیرقابل بازگشت است.",
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "انصراف",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await folderController.deleteFolder(folder);
                Get.back();

                // نمایش پیام موفقیت
                Get.snackbar("title", "پوشه «${folder.title}» با موفقیت حذف شد", backgroundColor: Colors.redAccent,);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("حذف"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFolderBottomSheet() {
    folderNameController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "ایجاد پوشه جدید",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: folderNameController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "نام پوشه",
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.folder, color: Colors.greenAccent),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {

                            if (folderNameController.text.isNotEmpty) {
                              await folderController.addFolder(folderNameController.text);
                              Get.back();

                              // نمایش پیام موفقیت
                             Get.snackbar("درود", "پوشه «${folderNameController.text}» با موفقیت ایجاد شد",backgroundColor: Colors.greenAccent);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "ایجاد پوشه",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "انصراف",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
