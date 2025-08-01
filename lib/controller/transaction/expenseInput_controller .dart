import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';

import '../../model/transaction/transaction.dart';

class CategoryExpense {
  String name;
  double percentage;
  Color color;
  Icon? icon;

  CategoryExpense({
    required this.name,
    required this.percentage,
    required this.color, this.icon,
  });
}

class TransactionController extends GetxController {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController expensesController = TextEditingController();

  // متغیرهای برای نمایش در صفحه مشاور مالی
  final RxInt currentIncome = 0.obs;
  final RxInt currentExpenses = 0.obs;
  final RxInt currentSavings = 0.obs;
  final RxString financialStatus = ''.obs;
  final RxString financialAdvice = ''.obs;

  // لیست تراکنش‌ها
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  // برای نگهداری دسته‌های هزینه
  final List<CategoryExpense> expenseCategories = [
    CategoryExpense(name: 'قبوض', percentage: 0.0, color: const Color(0xFFB91D73)),
    CategoryExpense(name: 'غذا', percentage: 0.0, color: const Color(0xFFFF6584)),
    CategoryExpense(name: 'حمل و نقل', percentage: 0.0, color: const Color(0xFFFFB480)),
    CategoryExpense(name: 'تفریح', percentage: 0.0, color: const Color(0xFFE55D87)),
    CategoryExpense(name: 'آموزش', percentage: 0.0, color: const Color(0xFF3F5EFB)),
    CategoryExpense(name: 'سلامتی', percentage: 0.0, color: const Color(0xFF19B5FE)),
    CategoryExpense(name: 'سایر', percentage: 0.0, color: const Color(0xFF6C63FF)),
  ];

  // برای ذخیره درصد هر دسته
  final List<TextEditingController> percentageControllers = [];

  // برای نمایش در چارت
  final RxList<PieChartSectionData> chartSections = <PieChartSectionData>[].obs;

  // مقادیر محاسبه شده
  late RxInt totalIncome = 0.obs;
  late RxInt totalExpenses = 0.obs;
  final RxInt savings = 0.obs;
  final RxDouble savingsPercentage = 0.0.obs;

  // وضعیت نمایش چارت
  final RxBool showChart = false.obs;

  // حالت انتخاب نوع تحلیل
  final RxInt selectedAnalysisType = 0.obs; // 0: ماهانه، 1: سالانه

  // ماه و سال فعلی
  final RxString currentMonth = ''.obs;
  final RxInt currentYear = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // ایجاد TextEditingController برای هر دسته
    for (var i = 0; i < expenseCategories.length; i++) {
      percentageControllers.add(TextEditingController(text: '0'));
    }

    // تنظیم تاریخ فعلی
    final now = DateTime.now();
    final persianMonths = [
      'فروردین', 'اردیبهشت', 'خرداد', 'تیر',
      'مرداد', 'شهریور', 'مهر', 'آبان',
      'آذر', 'دی', 'بهمن', 'اسفند'
    ];
    currentMonth.value = persianMonths[now.month - 1];
    currentYear.value = now.year;

    // بارگذاری تراکنش‌ها از Hive
    final transactionsBox = Hive.box<TransactionModel>('transactions');
    transactions.addAll(transactionsBox.values);

    // گوش دادن به تغییرات در جعبه تراکنش‌ها
    transactionsBox.watch().listen((event) {
      transactions.clear();
      transactions.addAll(transactionsBox.values);
    });
  }

  @override
  void onClose() {
    incomeController.dispose();
    expensesController.dispose();
    for (var controller in percentageControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  // تبدیل رشته عددی با جداکننده به عدد صحیح
  int parseFormattedNumber(String text) {
    if (text.isEmpty) return 0;
    return int.parse(text.replaceAll(',', '').replaceAll('.', ''));
  }

  // بررسی اعتبار درصدها (مجموع باید 100 باشد)
  bool validatePercentages() {
    double sum = 0;
    for (var controller in percentageControllers) {
      sum += double.tryParse(controller.text) ?? 0;
    }
    return (sum - 100).abs() < 0.01; // تقریباً 100
  }

  // محاسبه درصدهای پیش‌فرض برای تخصیص خودکار
  void calculateDefaultPercentages() {
    percentageControllers[0].text = '30'; // قبوض
    percentageControllers[1].text = '25'; // غذا
    percentageControllers[2].text = '15'; // حمل و نقل
    percentageControllers[3].text = '10'; // تفریح
    percentageControllers[4].text = '10'; // آموزش
    percentageControllers[5].text = '5';  // سلامتی
    percentageControllers[6].text = '5';  // سایر
  }

  // محاسبه و به‌روزرسانی مقادیر
  void calculateAndUpdate() {
    if (incomeController.text.isEmpty || expensesController.text.isEmpty) {
      Get.snackbar(
        'خطا',
        'لطفاً مقادیر درآمد و هزینه را وارد کنید',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    currentIncome.value = parseFormattedNumber(incomeController.text);
    currentExpenses.value = parseFormattedNumber(expensesController.text);
    currentSavings.value = currentIncome.value - currentExpenses.value;

    totalIncome.value = currentIncome.value;
    totalExpenses.value = currentExpenses.value;
    savings.value = currentSavings.value;

    if (totalIncome.value > 0) {
      savingsPercentage.value = (savings.value / totalIncome.value) * 100;
    } else {
      savingsPercentage.value = 0;
    }

    determineFinancialStatus();
    calculateDefaultPercentages();
    updateChartSections();
    showChart.value = true;
  }



  // دریافت داده‌های نمودار دایره‌ای
  Map<String, double> getPieChartData() {
    final Map<String, double> pieData = {};

    // مقداردهی اولیه برای تمام دسته‌ها
    for (var category in expenseCategories) {
      pieData[category.name] = 0.0;
    }

    // فیلتر تراکنش‌ها بر اساس نوع تحلیل (ماهانه یا سالانه)
    final now = DateTime.now();
    final filteredTransactions = transactions.where((transaction) {
      if (selectedAnalysisType.value == 0) {
        // ماهانه
        return transaction.date.month == now.month &&
            transaction.date.year == now.year &&
            transaction.type == TransactionType.expense;
      } else {
        // سالانه
        return transaction.date.year == now.year &&
            transaction.type == TransactionType.expense;
      }
    });

    // جمع‌آوری هزینه‌ها برای هر دسته
    for (var transaction in filteredTransactions) {
      final categoryName = transaction.category.persianName;
      pieData[categoryName] = (pieData[categoryName] ?? 0) + transaction.amount.toDouble();
    }

    // حذف دسته‌هایی که مقدار صفر دارند
    pieData.removeWhere((key, value) => value == 0);

    return pieData;
  }

  // تعیین وضعیت مالی و توصیه‌ها بر اساس درآمد و هزینه
  void determineFinancialStatus() {
    double savingRate = savingsPercentage.value;

    if (savingRate >= 30) {
      financialStatus.value = 'عالی';
      financialAdvice.value = 'شما در وضعیت مالی عالی هستید. پیشنهاد می‌شود بخشی از پس‌انداز خود را در سرمایه‌گذاری‌های کم‌خطر قرار دهید.';
    } else if (savingRate >= 20) {
      financialStatus.value = 'خوب';
      financialAdvice.value = 'وضعیت مالی شما خوب است. پیشنهاد می‌شود پس‌انداز خود را افزایش دهید و برای اهداف بلندمدت برنامه‌ریزی کنید.';
    } else if (savingRate >= 10) {
      financialStatus.value = 'متوسط';
      financialAdvice.value = 'وضعیت مالی شما متوسط است. پیشنهاد می‌شود هزینه‌های غیرضروری را کاهش داده و پس‌انداز بیشتری داشته باشید.';
    } else if (savingRate >= 0) {
      financialStatus.value = 'ضعیف';
      financialAdvice.value = 'وضعیت مالی شما ضعیف است. پیشنهاد می‌شود هزینه‌های خود را کنترل کرده و منابع درآمدی جدید پیدا کنید.';
    } else {
      financialStatus.value = 'بحرانی';
      financialAdvice.value = 'شما در وضعیت بحرانی مالی هستید. ضروری است که هزینه‌های خود را به شدت کاهش داده و از مشاوره مالی تخصصی کمک بگیرید.';
    }
  }

  // به‌روزرسانی بخش‌های چارت
  void updateChartSections() {
    chartSections.clear();

    for (var i = 0; i < expenseCategories.length; i++) {
      double percentage = double.tryParse(percentageControllers[i].text) ?? 0;
      expenseCategories[i].percentage = percentage;

      if (percentage > 0) {
        chartSections.add(
          PieChartSectionData(
            value: percentage,
            title: '${percentage.toStringAsFixed(0)}%',
            color: expenseCategories[i].color,
            radius: 100,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        );
      }
    }
  }

  // ذخیره تراکنش‌ها از صفحه مشاور مالی
  void saveTransactions(int income, int expenses) {
    addTransaction(
      income: income,
      expenses: expenses,
    );
  }

  // افزودن تراکنش
  void addTransaction({
    required int income,
    required int expenses,
    List<int>? categoryAmounts,
  }) {
    final transactionsBox = Hive.box<TransactionModel>('transactions');
    final now = DateTime.now();
    try {
      // ثبت درآمد
      final incomeTransaction = TransactionModel.create(
        title: 'درآمد ${currentMonth.value}',
        amount: income,
        date: now,
        category: Category.salary,
        type: TransactionType.income,
        note: 'ثبت شده از بخش تحلیل مالی',
      );

      transactionsBox.add(incomeTransaction);

      // اگر مقادیر دسته‌بندی ارسال شده باشد از آنها استفاده می‌کنیم
      // در غیر این صورت از درصدهای پیش‌فرض استفاده می‌کنیم
      if (categoryAmounts != null && categoryAmounts.length == expenseCategories.length) {
        for (var i = 0; i < expenseCategories.length; i++) {
          if (categoryAmounts[i] > 0) {
            addExpenseTransaction(i, categoryAmounts[i], now);
          }
        }
      } else {
        // استفاده از درصدها برای محاسبه مقدار هر دسته
        for (var i = 0; i < expenseCategories.length; i++) {
          double percentage = double.tryParse(percentageControllers[i].text) ?? 0;
          if (percentage > 0) {
            int amount = (expenses * percentage / 100).round();
            addExpenseTransaction(i, amount, now);
          }
        }
      }

      Get.snackbar(
        'ثبت موفق',
        'اطلاعات مالی با موفقیت ثبت شد',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در ثبت اطلاعات: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // افزودن تراکنش هزینه
  void addExpenseTransaction(int categoryIndex, int amount, DateTime date) {
    final transactionsBox = Hive.box<TransactionModel>('transactions');

    Category category;
    switch (categoryIndex) {
      case 0:
        category = Category.bills;
        break;
      case 1:
        category = Category.food;
        break;
      case 2:
        category = Category.transport;
        break;
      case 3:
        category = Category.entertainment;
        break;
      case 4:
        category = Category.education;
        break;
      case 5:
        category = Category.health;
        break;
      default:
        category = Category.other_expense;
    }

    final expenseTransaction = TransactionModel.create(
      title: '${expenseCategories[categoryIndex].name} ${currentMonth.value}',
      amount: amount,
      date: date,
      category: category,
      type: TransactionType.expense,
      note: 'ثبت شده از بخش تحلیل مالی',
    );

    transactionsBox.add(expenseTransaction);
  }

  // تغییر نوع تحلیل (ماهانه/سالانه)
  void changeAnalysisType(int type) {
    selectedAnalysisType.value = type;
    updateChartSections();
  }

  // فرمت‌کننده اعداد با جداکننده هزارتایی
  String formatNumber(int number) {
    final formatter = intl.NumberFormat('#,###');
    return formatter.format(number);
  }
  /// بارگذاری همه تراکنش‌ها از Hive به لیستِ واکنش‌گرا
  void loadTransactions() {
    try {
      final box = Hive.box<TransactionModel>('transactions');
      print('تعداد تراکنش‌های موجود: ${box.length}'); // لاگ برای دیباگ

      // محاسبه درآمد، هزینه و پس‌انداز
      double totalIncome = 0;
      double totalExpense = 0.0;

      for (var transaction in box.values) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      currentIncome.value = totalIncome as int ;
      currentExpenses.value = totalExpense as int;
      currentSavings.value = (totalIncome - totalExpense) as int;

      // به‌روزرسانی اجباری UI
      update();
    } catch (e) {
      print('خطا در بارگذاری تراکنش‌ها: $e');
    }
  }

  /// حذف یک تراکنش از Hive و به‌روزرسانی لیست و پس‌انداز
  void deleteTransaction(TransactionModel transaction, int index) {
    final box = Hive.box<TransactionModel>('transactions');

    // ذخیره مقدار تراکنش قبل از حذف
    final amount = transaction.amount;
    final type = transaction.type;

    // حذف از Hive
    box.delete(transaction.key).then((_) {
      // حذف از لیست نمایشی
      transactions.remove(transaction);

      // به‌روزرسانی مقادیر بر اساس نوع تراکنش
      if (type == TransactionType.expense) {
        // اگر هزینه بود، مقدار آن از کل هزینه‌ها کم می‌شود
        currentExpenses.value -= amount;
        totalExpenses.value -= amount;
      } else if (type == TransactionType.income) {
        // اگر درآمد بود، مقدار آن از کل درآمدها کم می‌شود
        currentIncome.value -= amount;
        totalIncome.value -= amount;
      }

      // به‌روزرسانی پس‌انداز
      currentSavings.value = currentIncome.value - currentExpenses.value;
      savings.value = currentSavings.value;

      // به‌روزرسانی درصد پس‌انداز
      if (totalIncome.value > 0) {
        savingsPercentage.value = (savings.value / totalIncome.value) * 100;
      } else {
        savingsPercentage.value = 0;
      }

      // به‌روزرسانی وضعیت مالی و توصیه‌ها
      determineFinancialStatus();

      // به‌روزرسانی نمودار اگر نمایش داده می‌شود
      if (showChart.value) {
        updateChartSections();
      }

      // اعلان موفقیت
      Get.snackbar(
        'عملیات موفق',
        'تراکنش با موفقیت حذف شد',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

    }).catchError((e) {
      // اعلان خطا
      Get.snackbar(
        'خطا',
        'خطا در حذف تراکنش: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
}

