import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/personController/person_controoler.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalityScreen4 extends StatelessWidget {
  const PersonalityScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalityController controller = Get.find();

    RxInt selectedOption = (-1).obs;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.greenAccent),
        ),
        backgroundColor: Colors.transparent,
        title: Text("تحلیل شخصیت", style: GoogleFonts.roboto(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "سوال ۴: نگاه شما به زندگی چطوره؟",
              style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ...List.generate(controller.options4.length, (index) {
              return Obx(() => GestureDetector(
                onTap: () => selectedOption.value = index,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedOption.value == index
                        ? Colors.greenAccent.withOpacity(0.2)
                        : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedOption.value == index ? Colors.greenAccent : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selectedOption.value == index ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(controller.options4[index], style: GoogleFonts.roboto(color: Colors.white))),
                    ],
                  ),
                ),
              ));
            }),
            const SizedBox(height: 30),
            Center(
              child: Obx(() => ElevatedButton(
                onPressed: selectedOption.value != -1
                    ? () {
                  controller.saveAnswer(selectedOption.value);
                  Get.toNamed("PersonalityScreen5");

                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text("بعدی", style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}