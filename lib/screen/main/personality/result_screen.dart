import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../controller/personController/person_controoler.dart';
import '../../../widget/button/custom_butten.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final PersonalityController controller = Get.put(PersonalityController());
  late String personalityType;
  String aiAnalysis = '';
  bool isLoadingAnalysis = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    personalityType = controller.calculatePersonality();
    _getAIAnalysis();
  }

  Future<void> _getAIAnalysis() async {
    try {
      setState(() {
        isLoadingAnalysis = true;
        errorMessage = '';
      });

      // روش 1: استفاده از OpenAI API
      await _getOpenAIAnalysis();

      // روش 2: استفاده از Gemini API (جایگزین)
      // await _getGeminiAnalysis();

    } catch (e) {
      setState(() {
        errorMessage = 'خطا در دریافت تحلیل: ${e.toString()}';
        isLoadingAnalysis = false;
      });
    }
  }

  Future<void> _getOpenAIAnalysis() async {
    const String openAiApiKey = 'YOUR_OPENAI_API_KEY'; // کلید API خود را وارد کنید
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAiApiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'شما یک روانشناس متخصص هستید. تحلیل کاملی از انواع شخصیت ارائه دهید.'
          },
          {
            'role': 'user',
            'content': '''
لطفاً تحلیل کاملی از شخصیت "$personalityType" ارائه دهید که شامل:
1. توضیح کلی این نوع شخصیت
2. نقاط قوت
3. نقاط ضعف
4. مناسب‌ترین شغل‌ها
5. روابط اجتماعی
6. توصیه‌های شخصی برای رشد
تحلیل را به فارسی و به صورت مفصل ارائه دهید.
            '''
          }
        ],
        'max_tokens': 1500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        aiAnalysis = data['choices'][0]['message']['content'];
        isLoadingAnalysis = false;
      });
    } else {
      throw Exception('Failed to get AI analysis: ${response.statusCode}');
    }
  }

  Future<void> _getGeminiAnalysis() async {
    const String geminiApiKey = 'YOUR_GEMINI_API_KEY'; // کلید API خود را وارد کنید
    final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$geminiApiKey';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{
          'parts': [{
            'text': '''
لطفاً تحلیل کاملی از شخصیت "$personalityType" ارائه دهید که شامل:
1. توضیح کلی این نوع شخصیت
2. نقاط قوت
3. نقاط ضعف
4. مناسب‌ترین شغل‌ها
5. روابط اجتماعی
6. توصیه‌های شخصی برای رشد
تحلیل را به فارسی و به صورت مفصل ارائه دهید.
            '''
          }]
        }]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        aiAnalysis = data['candidates'][0]['content']['parts'][0]['text'];
        isLoadingAnalysis = false;
      });
    } else {
      throw Exception('Failed to get Gemini analysis: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.greenAccent),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "نتیجه تحلیل شخصیت",
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body:Column(
          children: [
            // بخش نمایش نوع شخصیت
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_search_rounded,
                    size: 80,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "شخصیت شما:",
                    style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    personalityType,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // // بخش تحلیل هوش مصنوعی
            // Container(
            //   margin: const EdgeInsets.all(16),
            //   padding: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF1E1E1E),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           const Icon(
            //             Icons.psychology,
            //             color: Colors.greenAccent,
            //             size: 24,
            //           ),
            //           const SizedBox(width: 8),
            //           Text(
            //             "تحلیل هوش مصنوعی",
            //             style: GoogleFonts.roboto(
            //               fontSize: 18,
            //               color: Colors.greenAccent,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 16),
            //
            //       if (isLoadingAnalysis)
            //         const Center(
            //           child: Column(
            //             children: [
            //               CircularProgressIndicator(color: Colors.greenAccent),
            //               SizedBox(height: 16),
            //               Text(
            //                 "در حال تحلیل شخصیت شما...",
            //                 style: TextStyle(color: Colors.white70),
            //               ),
            //             ],
            //           ),
            //         )
            //       else if (errorMessage.isNotEmpty)
            //         Column(
            //           children: [
            //             const Icon(
            //               Icons.error_outline,
            //               color: Colors.redAccent,
            //               size: 48,
            //             ),
            //             const SizedBox(height: 8),
            //             Text(
            //               errorMessage,
            //               style: const TextStyle(color: Colors.redAccent),
            //               textAlign: TextAlign.center,
            //             ),
            //             const SizedBox(height: 16),
            //             ElevatedButton(
            //               onPressed: _getAIAnalysis,
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: Colors.greenAccent,
            //                 foregroundColor: Colors.black,
            //               ),
            //               child: const Text("تلاش مجدد"),
            //             ),
            //           ],
            //         )
            //       else
            //         Text(
            //           aiAnalysis,
            //           style: GoogleFonts.roboto(
            //             fontSize: 14,
            //             color: Colors.white,
            //             height: 1.6,
            //           ),
            //           textAlign: TextAlign.justify,
            //         ),
            //     ],
            //   ),
            // ),

            // دکمه ادامه
            Padding(
              padding: const EdgeInsets.all(40),
              child: CustomElevatedButton(
                text: 'ادامه',
                color: Colors.black,
                textColor: Colors.greenAccent,
                shadowColor: Colors.greenAccent,
                onPressed: () {
                  Get.toNamed("DashboardPage");
                },
              ),
            ),
          ],
        ),
      );
  }
}