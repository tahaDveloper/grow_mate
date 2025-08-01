import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../controller/transaction/expenseInput_controller .dart';
import '../../../util/numberFormat/number_format.dart';
import '../../../widget/finance/finance_widget.dart';
import '../../../widget/paint/holePaint.dart';
import '../../../widget/title/title_custom.dart';

class FinancialAdvisorScreen extends StatefulWidget {
  const FinancialAdvisorScreen({super.key});

  @override
  State<FinancialAdvisorScreen> createState() => _FinancialAdvisorScreenState();
}

class _FinancialAdvisorScreenState extends State<FinancialAdvisorScreen> {
  final TransactionController transactionController = Get.put(TransactionController());

  @override
  void initState() {
    super.initState();
    // اگر نیاز به مقداردهی اولیه باشد اینجا انجام می‌شود
  }

  @override
  void dispose() {
    // در صورت نیاز به آزادسازی منابع
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        height: Get.height,
        child: Stack(
          children: [
            // تصویر پس‌زمینه
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/image/ChatGPT Image May 5, 2025, 04_11_26 PM.png",
                width: Get.width,
                fit: BoxFit.cover,
              ),
            ),

            // بخش نمایش چارت (در صورت وجود)
            Obx(() => transactionController.showChart.value
                ? buildChartSection()
                : const SizedBox.shrink()),

            // فرم ورودی در پایین صفحه
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 320,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(Get.width, Get.height * 0.4),
                      painter: BNBCustomPainter(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40, left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildInputField("درآمد ماهیانه (تومان)", transactionController.incomeController),
                            const SizedBox(height: 20),
                            buildInputField("هزینه‌ها (تومان)", transactionController.expensesController),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (transactionController.incomeController.text.isNotEmpty &&
                                        transactionController.expensesController.text.isNotEmpty) {
                                      int income = parseFormattedNumber(transactionController.incomeController.text);
                                      int expenses = parseFormattedNumber(transactionController.expensesController.text);

                                      // محاسبه و نمایش آنالیز
                                      transactionController.calculateAndUpdate();

                                      // باز کردن دیالوگ تأیید برای ثبت تراکنش‌ها
                                      showConfirmationDialog(income, expenses);
                                    } else {
                                      Get.snackbar(
                                        'خطا',
                                        'لطفاً مقادیر درآمد و هزینه را وارد کنید',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Text("تحلیل کن",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed("/ExpenseTrackerScreen");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Text("حساب هزینه ها",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
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
  // ساخت بخش نمودار و تحلیل
  Widget buildChartSection() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleCustom(
              text:  "تحلیل مالی",
              color: Colors.greenAccent,
              fontSize: 18, fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.greenAccent,
                      value: transactionController.currentIncome.value.toDouble(),
                      title: 'درآمد',
                      radius: 60,
                      titleStyle: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value: transactionController.currentExpenses.value.toDouble(),
                      title: 'هزینه',
                      radius: 60,
                      titleStyle: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (transactionController.currentSavings.value > 0)
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: transactionController.currentSavings.value.toDouble(),
                        title: 'پس‌انداز',
                        radius: 60,
                        titleStyle: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              "وضعیت مالی شما: ${transactionController.financialStatus.value}",
              style: GoogleFonts.roboto(
                color: getStatusColor(transactionController.financialStatus.value),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
            const SizedBox(height: 15),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               ElevatedButton(
                 onPressed: () {
                   transactionController.showChart.value = false;
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.greenAccent.withOpacity(0.7),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                   ),
                 ),
                 child: TitleCustom(
                   text: "بستن",
                   fontWeight: FontWeight.w800,
                   fontSize: 16,
                   color: Colors.black,
                 ),
               ),
               ElevatedButton(
                 onPressed: () {
                   Get.toNamed("ConsultingScreen");
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.green,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                   ),
                 ),
                 child: TitleCustom(
                   text: "مشاور مالی",
                   fontWeight: FontWeight.w800,
                   fontSize: 16,
                   color: Colors.black,
                 ),
               ),
             ],
           )
          ],
        ),
      ),
    );
  }
  // نمایش دیالوگ تأیید برای ثبت تراکنش‌ها
  void showConfirmationDialog(int income, int expenses) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.greenAccent, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "آیا می‌خواهید این مقادیر را در تاریخچه تراکنش‌ها ثبت کنید؟",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // بستن دیالوگ
                      // ثبت تراکنش‌ها در تاریخچه
                      transactionController.saveTransactions(income, expenses);
                      Get.snackbar(
                        'موفق',
                        'تراکنش‌ها با موفقیت ثبت شدند',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "بله",
                      style: GoogleFonts.roboto(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // بستن دیالوگ
                    },
                    child: Text(
                      "خیر",
                      style: GoogleFonts.roboto(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
