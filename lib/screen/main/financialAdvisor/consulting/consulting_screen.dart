
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import '../../../../controller/transaction/expenseInput_controller .dart';
import '../../../../controller/transaction/financeAi/modelAi.dart';
import '../../../../controller/transaction/financeAi/modelStrategy.dart';
import '../../../../widget/finance/advance_finance_widget.dart';

class ConsultingScreen extends StatefulWidget {
  const ConsultingScreen({Key? key}) : super(key: key);

  @override
  State<ConsultingScreen> createState() => _ConsultingScreenState();
}

class _ConsultingScreenState extends State<ConsultingScreen> with TickerProviderStateMixin {
  final TransactionController _transactionController = Get.put(TransactionController());
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late OpenAI _openAI;

  // لیست گفتگوها
  final RxList<ChatMessage> _messages = <ChatMessage>[].obs;
  final RxBool _isTyping = false.obs;
  final RxBool _isLoading = true.obs;
  final RxDouble _savingsProgress = 0.0.obs;

  // استراتژی‌های مالی توصیه شده
  final RxList<FinancialStrategy> _recommendedStrategies = <FinancialStrategy>[].obs;

  // تعریف استراتژی‌های پیش‌فرض
  final List<FinancialStrategy> _defaultStrategies = [
    FinancialStrategy(
      title: 'قانون ۵۰/۳۰/۲۰',
      description: '۵۰٪ برای نیازهای اساسی، ۳۰٪ برای خواسته‌ها و ۲۰٪ برای پس‌انداز',
      icon: Icons.pie_chart,
      color: Colors.blue,
      isRecommended: false,
    ),
    FinancialStrategy(
      title: 'پس‌انداز اضطراری',
      description: 'حداقل معادل ۳ تا ۶ ماه هزینه‌های زندگی را برای مواقع اضطراری کنار بگذارید',
      icon: Icons.savings,
      color: Colors.amber,
      isRecommended: false,
    ),
    FinancialStrategy(
      title: 'کاهش بدهی‌ها',
      description: 'ابتدا بدهی‌های با نرخ بهره بالا را تسویه کنید',
      icon: Icons.trending_down,
      color: Colors.red,
      isRecommended: false,
    ),
    FinancialStrategy(
      title: 'سرمایه‌گذاری متنوع',
      description: 'سبد متنوعی از سرمایه‌گذاری‌ها را ایجاد کنید تا ریسک کمتری داشته باشید',
      icon: Icons.account_balance,
      color: Colors.green,
      isRecommended: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat(reverse: true);

    // مقداردهی اولیه OpenAI
    _openAI = OpenAI.instance.build(
      token: 'YOUR_API_KEY_HERE', // کلید API خود را اینجا قرار دهید
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 60),
        connectTimeout: const Duration(seconds: 60),
      ),
    );

    // اضافه کردن پیام خوش‌آمدگویی
    _messages.add(
      ChatMessage(
        text: 'سلام! من مشاور مالی هوشمند شما هستم. چطور می‌توانم به شما کمک کنم؟',
        isUserMessage: false,
      ),
    );

    // بارگذاری اطلاعات مالی کاربر
    _loadUserFinancialData();

    // تشخیص استراتژی‌های مناسب
    _detectRecommendedStrategies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // بارگذاری اطلاعات مالی کاربر
  void _loadUserFinancialData() {
    // شبیه‌سازی بارگذاری داده‌ها
    Future.delayed(const Duration(seconds: 2), () {
      // اگر داده‌های واقعی وجود نداشته باشد، می‌توانید از مقادیر پیش‌فرض استفاده کنید
      if (_transactionController.totalIncome.value == 0 &&
          _transactionController.totalExpenses.value == 0) {
        _transactionController.loadTransactions();
      }

      // محاسبه درصد پیشرفت پس‌انداز نسبت به هدف (فرض کنید هدف ۳۰٪ درآمد است)
      final targetSavingsRate = 30.0;
      final currentSavingsRate = _transactionController.savingsPercentage.value;
      _savingsProgress.value = (currentSavingsRate / targetSavingsRate).clamp(0.0, 1.0);

      _isLoading.value = false;
    });
  }

  // تشخیص استراتژی‌های مناسب برای کاربر
  void _detectRecommendedStrategies() {
    Future.delayed(const Duration(seconds: 3), () {
      final savingsRate = _transactionController.savingsPercentage.value;

      _recommendedStrategies.clear();

      if (savingsRate < 10) {
        // اگر نرخ پس‌انداز کمتر از ۱۰٪ باشد
        _defaultStrategies[0].isRecommended = true; // قانون ۵۰/۳۰/۲۰
        _defaultStrategies[2].isRecommended = true; // کاهش بدهی‌ها
        _recommendedStrategies.add(_defaultStrategies[0]);
        _recommendedStrategies.add(_defaultStrategies[2]);
      } else if (savingsRate < 20) {
        // اگر نرخ پس‌انداز بین ۱۰٪ تا ۲۰٪ باشد
        _defaultStrategies[1].isRecommended = true; // پس‌انداز اضطراری
        _recommendedStrategies.add(_defaultStrategies[1]);
      } else {
        // اگر نرخ پس‌انداز بیش از ۲۰٪ باشد
        _defaultStrategies[3].isRecommended = true; // سرمایه‌گذاری متنوع
        _recommendedStrategies.add(_defaultStrategies[3]);
      }
    });
  }

  // ارسال سوال به AI
  void _sendQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) return;

    // اضافه کردن سوال کاربر به لیست گفتگوها
    _messages.add(
      ChatMessage(
        text: question,
        isUserMessage: true,
      ),
    );

    // پاک کردن فیلد متنی
    _questionController.clear();

    // اسکرول به پایین لیست گفتگوها
    _scrollToBottom();

    // نشان دادن وضعیت تایپ کردن
    _isTyping.value = true;

    try {
      // آماده‌سازی متن زمینه برای AI
      final savingsRate = _transactionController.savingsPercentage.value.toStringAsFixed(1);
      final financialStatus = _transactionController.financialStatus.value;
      final income = _transactionController.formatNumber(_transactionController.totalIncome.value);
      final expenses = _transactionController.formatNumber(_transactionController.totalExpenses.value);
      final savings = _transactionController.formatNumber(_transactionController.savings.value);

      final contextPrompt = """
      من یک مشاور مالی هوشمند هستم و به شما کمک می‌کنم. اطلاعات مالی شما:
      - درآمد ماهانه: $income تومان
      - هزینه‌های ماهانه: $expenses تومان
      - پس‌انداز ماهانه: $savings تومان
      - نرخ پس‌انداز: $savingsRate درصد
      - وضعیت مالی: $financialStatus
      
      سوال کاربر: $question
      """;

      // استفاده از ChatGPT API
      final request = ChatCompleteText(
        model: Gpt4ChatModel(),
        messages: [
          Map.of({"role": "system", "content": contextPrompt}),
          Map.of({"role": "user", "content": question}),
        ],
        maxToken: 1000,
      );

      final response = await _openAI.onChatCompletion(request: request);

      // اضافه کردن پاسخ AI به لیست گفتگوها
      if (response != null && response.choices.isNotEmpty) {
        _messages.add(
          ChatMessage(
            text: response.choices.first.message!.content,
            isUserMessage: false,
          ),
        );
      } else {
        _messages.add(
          ChatMessage(
            text: 'متأسفانه در دریافت پاسخ مشکلی پیش آمد. لطفاً دوباره تلاش کنید.',
            isUserMessage: false,
          ),
        );
      }
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: 'متأسفانه در ارتباط با مشاور هوشمند مشکلی پیش آمد. لطفاً دوباره تلاش کنید.',
          isUserMessage: false,
        ),
      );
    } finally {
      _isTyping.value = false;
      _scrollToBottom();
    }
  }
  // اسکرول به پایین لیست گفتگوها
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF121212),
      appBar: AppBar(
        leading: Text(""),
        actions: [
          RotatedBox(quarterTurns: 2,child:           IconButton(onPressed: () {
            Get.back();
          }, icon: Icon(Icons.arrow_back_ios,color: Colors.greenAccent,)),)

        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Obx(
              () => _isLoading.value
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/sport.json',
                  height: 200.0,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
                const SizedBox(height: 20),
                Text(
                  'در حال بارگذاری اطلاعات مالی...',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          )
              : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF121212),
                  Colors.black,
                ],
              ),
            ),
            child: Column(
              children: [
                buildFinancialSummary(),
                buildRecommendedStrategies(),
                buildChatSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildFinancialSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'خلاصه وضعیت مالی',
                style: GoogleFonts.vazirmatn(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: getStatusColor(_transactionController.financialStatus.value),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Obx(
                      () => Text(
                    _transactionController.financialStatus.value,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: buildFinancialInfoCard(
                  'درآمد',
                  _transactionController.formatNumber(_transactionController.totalIncome.value),
                  'تومان',
                  Icons.arrow_upward,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildFinancialInfoCard(
                  'هزینه',
                  _transactionController.formatNumber(_transactionController.totalExpenses.value),
                  'تومان',
                  Icons.arrow_downward,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildFinancialInfoCard(
                  'پس‌انداز',
                  _transactionController.formatNumber(_transactionController.savings.value),
                  'تومان',
                  Icons.savings,
                  Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'وضعیت پس‌انداز (هدف: ۳۰٪)',
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
                () => LinearProgressIndicator(
              value: _savingsProgress.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                getSavingsProgressColor(_savingsProgress.value),
              ),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '۰٪',
                style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Obx(
                    () => Text(
                  '${_transactionController.savingsPercentage.value.toStringAsFixed(1)}٪',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '۳۰٪',
                style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // بخش استراتژی‌های توصیه‌شده
  Widget buildRecommendedStrategies() {
    return Container(
      height: Get.height*0.23,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'استراتژی‌های توصیه‌شده',
            style: GoogleFonts.vazirmatn(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
                  () => _recommendedStrategies.isEmpty
                  ? Center(
                child: Text(
                  'در حال بارگذاری استراتژی‌ها...',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recommendedStrategies.length,
                itemBuilder: (context, index) {
                  final strategy = _recommendedStrategies[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: strategy.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: strategy.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            strategy.icon,
                            color: strategy.color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                strategy.title,
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                strategy.description,
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بخش گفتگو با مشاور هوشمند
  Widget buildChatSection() {
    return Container(
      height: Get.height*0.5,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'گفتگو با مشاور هوشمند',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: Get.height*0.3,
              child: Obx(
                    () => ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return buildChatBubble(message);
                  },
                ),
              ),
            ),
          ),
          Obx(
                () => _isTyping.value
                ? Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'در حال تایپ...',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox(),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    style: GoogleFonts.vazirmatn(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'سوال خود را بپرسید...',
                      hintStyle: GoogleFonts.vazirmatn(
                        color: Colors.white70,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    textDirection: TextDirection.rtl,
                    onSubmitted: (_) => _sendQuestion(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendQuestion,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}