import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "GrowMate",
          style: GoogleFonts.roboto(fontSize: 22, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // AI services
            _aiServices(),
          ],
        ),
      ),
    );
  }

  Widget _aiServices() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          serviceCard("تحلیل شخصیت",Image.asset(
            "assets/image/perspective_matte-35-128x128.png",
            width: 90,
            height: 90,
          ), "/ResultScreen"),

          serviceCard("رشد فردی", Image.asset(
            "assets/image/personal2.png",
            width: 90,
            height: 90,
          ), "/PersonalGrowthApp"),

          serviceCard("مشاوره مالی", Image.asset(
            "assets/image/perspective_matte-380-128x128.png",
            width: 90,
            height: 90,
          ), "/ConsultingScreen"),

          serviceCard("پروفایل AI",Image.asset(
            "assets/image/perspective_matte-69-128x128.png",
            width: 90,
            height: 90,
          ), "/AIImageGeneratorScreen"),

          serviceCard("ورزش", Image.asset(
                "assets/image/Fitness-128x128.png",
                width: 90,
                height: 90,
              ), "/SportsPage"),

          serviceCard("تراپیست", Image.asset(
              "assets/image/perspective_matte-359-128x128.png",
            width: 90,
            height: 90,
            ), "/TherapistPage",
          ),
          serviceCard("مهارت های جدید", Image.asset(
            "assets/image/skill.png",
            width: 90,
            height: 90,
          ), "/SkillsPage",
          ),
        ],
      ),
    );
  }

  Widget serviceCard(String title, Widget icon, String route) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.roboto(color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
