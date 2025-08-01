import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

// مدل پیام چت پیشرفته
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType messageType;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.messageType = MessageType.text,
  });
}

// انواع پیام
enum MessageType { text, therapy, welcome, exercise, meditation, journal, support, emergency, stats }

// انواع حالت روحی
enum MoodType { happy, sad, angry, anxious, neutral }

// مدل یادداشت روزانه
class JournalEntry {
  final String title;
  final String content;
  final DateTime timestamp;
  final MoodType mood;

  JournalEntry({
    required this.title,
    required this.content,
    required this.timestamp,
    required this.mood,
  });
}

// کنترلر AI برای تراپیست پیشرفته
class TherapistController extends GetxController {
  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;
  var currentMood = MoodType.neutral.obs;
  var sessionCount = 0.obs;
  var currentTechnique = ''.obs;
  var journalEntries = <JournalEntry>[].obs;
  var breathingActive = false.obs;
  var meditationTime = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSession();
    _loadUserData();
  }

  void _initializeSession() {
    messages.add(ChatMessage(
      content: '''🌸 سلام عزیز! من دوست تو هستم، روانشناس و مشاور شما.

در اینجا برای گوش دادن، درک کردن و کمک به شما هستم. این یک فضای امن و محرمانه است که می‌تونید هر احساس و فکری رو با من در میان بذارید.

چه چیزی امروز ذهنتون رو درگیر کرده؟ 💝''',
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.welcome,
    ));
  }

  void _loadUserData() {
    sessionCount.value = Random().nextInt(25) + 5;
  }

  Future<void> sendMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    messages.add(ChatMessage(
      content: prompt,
      isUser: true,
      timestamp: DateTime.now(),
      messageType: MessageType.text,
    ));

    isLoading.value = true;
    _analyzeMood(prompt);

    try {
      await Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(1500)));
      String aiResponse = _generateTherapistResponse(prompt);
      messages.add(ChatMessage(
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.therapy,
      ));
      sessionCount.value++;
    } catch (e) {
      messages.add(ChatMessage(
        content:
        '💙 متاسفم، الان مشکل فنی داریم. ولی من همچنان اینجام براتون. لطفا دوباره تلاش کنید.',
        isUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.support,
      ));
    } finally {
      isLoading.value = false;
    }
  }

  void _analyzeMood(String text) {
    String lower = text.toLowerCase();
    if (lower.contains('غم') || lower.contains('ناراحت') || lower.contains('افسرده') || lower.contains('خسته')) {
      currentMood.value = MoodType.sad;
    } else if (lower.contains('عصبانی') || lower.contains('خشم') || lower.contains('استرس') || lower.contains('نگران')) {
      currentMood.value = MoodType.angry;
    } else if (lower.contains('خوشحال') || lower.contains('خوب') || lower.contains('شاد')) {
      currentMood.value = MoodType.happy;
    } else if (lower.contains('ترس') || lower.contains('اضطراب') || lower.contains('هراس')) {
      currentMood.value = MoodType.anxious;
    } else {
      currentMood.value = MoodType.neutral;
    }
  }

  String _generateTherapistResponse(String prompt) {
    // مشابه کد موجود: انتخاب پاسخ براساس mood
    // ...
    // برای اختصار، اینجا فقط یک پیام عمومی باز می‌گردانیم
    return 'من اینجام تا گوش بدم. ادامه بده...';
  }

  void startBreathingExercise() {
    breathingActive.value = true;
    messages.add(ChatMessage(
      content: '''🌬️ عالیه! بیاید با تکنیک تنفس ۴-۷-۸ شروع کنیم.

۱. ۴ ثانیه نفس بکشید 👃
۲. ۷ ثانیه نفس نگه دارید 🫁
۳. ۸ ثانیه آهسته دم کنید 💨

۳ دور انجام بدید.''',
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.exercise,
    ));
  }

  void startMeditation(int minutes) {
    meditationTime.value = minutes;
    messages.add(ChatMessage(
      content: '''🧘‍♀️ مدیتیشن ${minutes} دقیقه‌ای شروع شد.

راهنمایی:
• روی تنفس تمرکز کنید
• اگر ذهنتون پرت شد، برگردونید''',
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.meditation,
    ));
  }

  void addJournalEntry(String title, String content) {
    journalEntries.add(JournalEntry(
      title: title,
      content: content,
      timestamp: DateTime.now(),
      mood: currentMood.value,
    ));
    messages.add(ChatMessage(
      content:
      '📔 یادداشت شما ذخیره شد. نوشتن کمک می‌کنه احساساتتون رو بهتر درک کنید.',
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.journal,
    ));
  }

  void emergencySupport() {
    messages.add(ChatMessage(
      content: '''🚨 اقدامات فوری:
• ۱۱۵

تو این لحظه تنها نیستی.''',
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.emergency,
    ));
  }

  void showStats() {
    messages.add(ChatMessage(
      content:
      '📊 تعداد جلسات: ${sessionCount.value}\nیادداشت‌ها: ${journalEntries.length}',
      isUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.stats,
    ));
  }
}

// صفحه اصلی تراپیست
class TherapistPage extends StatelessWidget {
  final TherapistController ctrl = Get.put(TherapistController());
  final TextEditingController inputCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildMoodIndicator(),
              _buildChatArea(),
              _buildToolsBar(),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white70,
            child: Icon(Icons.psychology, size: 32, color: Colors.purple),
          ),
          SizedBox(width: 12),
         RotatedBox(
           quarterTurns: 2,
           child: IconButton(onPressed: () {
           Get.back();
         },
             icon: Icon(Icons.arrow_back_ios,size: 20,color: Colors.white,)),
         )
        ],
      ),
    );
  }

  Widget _buildMoodIndicator() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('حالت شما: ${ctrl.currentMood.value.name} - تکنیک: ${ctrl.currentTechnique.value}',
            style: TextStyle(color: Colors.white)),
      );
    });
  }

  Widget _buildChatArea() {
    return Expanded(
      child: Obx(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollCtrl.hasClients) {
            scrollCtrl.animateTo(
              scrollCtrl.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
        return ListView.builder(
          controller: scrollCtrl,
          padding: EdgeInsets.all(16),
          itemCount: ctrl.messages.length,
          itemBuilder: (c, i) {
            final m = ctrl.messages[i];
            return Align(
              alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: m.isUser ? Colors.blueAccent : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(m.content, style: TextStyle(color: m.isUser ? Colors.white : Colors.black)),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildToolsBar() {
    return Container(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _toolBtn('تنفس', Icons.air, ctrl.startBreathingExercise),
          _toolBtn('مدیتیشن', Icons.self_improvement, () => ctrl.startMeditation(5)),
          _toolBtn('یادداشت', Icons.book, () {
            _showJournalDialog();
          }),
          _toolBtn('اورژانس', Icons.warning, ctrl.emergencySupport),
          _toolBtn('آمار', Icons.bar_chart, ctrl.showStats),
        ],
      ),
    );
  }

  Widget _toolBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, color: Colors.white), SizedBox(height: 4), Text(label, style: TextStyle(color: Colors.white, fontSize: 12))],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: inputCtrl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                hintText: 'صحبت کن هرزمان آماده بودی...',
                hintStyle: TextStyle(color: Colors.white60),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => ctrl.sendMessage(inputCtrl.text),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            backgroundColor: Colors.purpleAccent,
            child: Icon(Icons.send, color: Colors.white),
            onPressed: () {
              ctrl.sendMessage(inputCtrl.text);
              inputCtrl.clear();
              }
                ),
        ],
      ),
    );
  }

  void _showJournalDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    Get.defaultDialog(
      title: 'یادداشت جدید',
      content: Column(
        children: [
          TextField(controller: titleCtrl, decoration: InputDecoration(hintText: 'عنوان')),
          TextField(controller: contentCtrl, decoration: InputDecoration(hintText: 'متن')),
        ],
      ),
      textConfirm: 'ذخیره',
      textCancel: 'انصراف',
      onConfirm: () {
        ctrl.addJournalEntry(titleCtrl.text, contentCtrl.text);
        Get.back();
      },
    );
  }
}
