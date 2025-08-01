import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../controller/transaction/expenseInput_controller .dart';
import '../../../../model/transaction/transaction.dart';
import '../../../../util/numberFormat/number_format.dart';

class ExpenseTrackerScreen extends StatelessWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();

    // بارگذاری داده‌ها در زمان ورود به صفحه
    controller.loadTransactions();

    return FutureBuilder<Box<TransactionModel>>(
      future: Hive.openBox<TransactionModel>('transactions'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Center(
              child: Text(
                'خطا در بارگذاری داده‌ها: ${snapshot.error}',
                style: GoogleFonts.roboto(color: Colors.redAccent),
              ),
            ),
          );
        }

        final transactionsBox = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            title: Text(
              "محاسبه هزینه‌ها",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Financial Summary Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خلاصه مالی',
                          style: GoogleFonts.roboto(
                            color: Colors.greenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryItem(
                              label: 'درآمد',
                              value: controller.formatNumber(controller.currentIncome.value),
                              color: Colors.greenAccent,
                            ),
                            _buildSummaryItem(
                              label: 'هزینه‌ها',
                              value: controller.formatNumber(controller.currentExpenses.value),
                              color: Colors.redAccent,
                            ),
                          ],
                        )),
                        const SizedBox(height: 12),
                        Obx(() => _buildSummaryItem(
                          label: 'مانده حساب',
                          value: controller.formatNumber(controller.currentSavings.value),
                          color: controller.currentSavings.value >= 0 ? Colors.greenAccent : Colors.redAccent,
                          fullWidth: true,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Transaction List Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تاریخچه تراکنش‌ها',
                                style: GoogleFonts.roboto(
                                  color: Colors.greenAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh, color: Colors.greenAccent),
                                onPressed: () => controller.loadTransactions(),
                                tooltip: 'بارگذاری مجدد داده‌ها',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ValueListenableBuilder(
                            valueListenable: transactionsBox.listenable(),
                            builder: (context, Box<TransactionModel> box, _) {
                              final transactions = box.values.toList()
                                ..sort((a, b) => b.date.compareTo(a.date));

                              if (transactions.isEmpty) {
                                return Center(
                                  child: Text(
                                    'هیچ تراکنشی ثبت نشده است',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  return Dismissible(
                                    key: Key(transaction.id.toString()),
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      controller.deleteTransaction(transaction,index);

                                      },
                                    child: AnimatedOpacity(
                                      opacity: 1.0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Card(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: transaction.category.color.withOpacity(0.2),
                                            child: Icon(
                                              transaction.category.icon,
                                              color: transaction.category.color,
                                            ),
                                          ),
                                          title: Text(
                                            transaction.title,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${transaction.type == TransactionType.expense ? '-' : '+'}${controller.formatNumber(transaction.amount)} تومان',
                                            style: GoogleFonts.roboto(
                                              color: transaction.type == TransactionType.expense
                                                  ? Colors.redAccent
                                                  : Colors.greenAccent,
                                            ),
                                          ),
                                          trailing: Text(
                                            intl.DateFormat('yyyy/MM/dd HH:mm').format(transaction.date),
                                            style: GoogleFonts.roboto(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTransactionDialog(context, controller),
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.add, color: Colors.black),
            tooltip: 'افزودن تراکنش جدید',
          ),
        );
      },
    );
  }

  // Widget برای نمایش آیتم‌های خلاصه مالی
  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
    bool fullWidth = false
  }) {
    return fullWidth
        ? Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$value تومان',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    )
        : Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.roboto(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$value تومان',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

// به‌روزرسانی تابع _showAddTransactionDialog

  void _showAddTransactionDialog(BuildContext context, TransactionController controller) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    var selectedCategory = controller.expenseCategories.first;
    var selectedCategoryIndex = 0; // اضافه شده برای تعیین نمایه دسته
    var transactionType = TransactionType.expense;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'افزودن تراکنش جدید',
          style: GoogleFonts.roboto(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // نوع تراکنش
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('نوع تراکنش:', style: GoogleFonts.roboto(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => transactionType = TransactionType.income),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: transactionType == TransactionType.income
                                      ? Colors.greenAccent.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: transactionType == TransactionType.income
                                        ? Colors.greenAccent
                                        : Colors.white30,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'درآمد',
                                    style: GoogleFonts.roboto(
                                      color: transactionType == TransactionType.income
                                          ? Colors.greenAccent
                                          : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => transactionType = TransactionType.expense),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: transactionType == TransactionType.expense
                                      ? Colors.redAccent.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: transactionType == TransactionType.expense
                                        ? Colors.redAccent
                                        : Colors.white30,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'هزینه',
                                    style: GoogleFonts.roboto(
                                      color: transactionType == TransactionType.expense
                                          ? Colors.redAccent
                                          : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // مبلغ تراکنش
                TextFormField(
                  controller: amountController,
                  style: GoogleFonts.roboto(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'مبلغ (تومان)',
                    labelStyle: GoogleFonts.roboto(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.greenAccent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفاً مبلغ را وارد کنید';
                    }
                    if (double.tryParse(value.replaceAll(',', '')) == null ||
                        double.parse(value.replaceAll(',', '')) <= 0) {
                      return 'لطفاً مبلغ معتبر وارد کنید';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsSeparatorInputFormatter(),
                  ],
                ),
                const SizedBox(height: 16),
                // دسته‌بندی تراکنش
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('دسته‌بندی:', style: GoogleFonts.roboto(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: selectedCategoryIndex,
                            dropdownColor: const Color(0xFF1E1E1E),
                            items: List.generate(controller.expenseCategories.length, (index) {
                              final category = controller.expenseCategories[index];
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.category_rounded,
                                      color: category.color,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category.name,
                                      style: GoogleFonts.roboto(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCategoryIndex = value;
                                  selectedCategory = controller.expenseCategories[value];
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'انصراف',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
          ),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final title = titleController.text;
                final amount = int.parse(amountController.text.replaceAll(',', ''));

                if (transactionType == TransactionType.expense) {
                  // برای هزینه
                  controller.addExpenseTransaction(
                      selectedCategoryIndex,
                      amount,
                      DateTime.now()
                  );

                  // به‌روزرسانی مقادیر نمایشی
                  controller.currentExpenses.value += amount;
                  controller.currentSavings.value = controller.currentIncome.value - controller.currentExpenses.value;
                } else {
                  // برای درآمد
                  final incomeTransaction = TransactionModel.create(
                    title: title,
                    amount: amount,
                    date: DateTime.now(),
                    category: Category.salary,
                    type: TransactionType.income,
                    note: 'ثبت شده از طریق فرم',
                  );

                  Hive.box<TransactionModel>('transactions').add(incomeTransaction);

                  // به‌روزرسانی مقادیر نمایشی
                  controller.currentIncome.value += amount;
                  controller.currentSavings.value = controller.currentIncome.value - controller.currentExpenses.value;
                }

                // به‌روزرسانی تعیین وضعیت مالی
                controller.determineFinancialStatus();

                Navigator.pop(context);
              }
            },
            child: Text(
              'ذخیره',
              style: GoogleFonts.roboto(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}