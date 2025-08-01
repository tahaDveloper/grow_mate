import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Get.toNamed("SplashPage2");
    });

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SizedBox.expand(
        child: Image.asset(
          "assets/image/intro.png",
          fit: BoxFit.cover, // تصویر تمام صفحه را پر می‌کند
        ),
      ),
    );
  }
}


class SplashPage2 extends StatelessWidget {
  const SplashPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body:

    Directionality(
    textDirection: TextDirection.rtl,
    child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "به GrowMate خوش اومدی 🌱",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "با هوش مصنوعی مسیر رشد شخصی‌تو شروع کن",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.toNamed('/PersonalityScreen1'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C896),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                "شروع کن",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
