import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

// کنترلر AI برای ارسال درخواست و ذخیره پاسخ
class AIController extends GetxController {
  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;
  var currentWorkout = ''.obs;
  var streak = 0.obs;
  var totalSessions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _addWelcomeMessage();
    _loadUserStats();
  }

  void _addWelcomeMessage() {
    messages.add(ChatMessage(
      content: '🏋️‍♂️ سلام! من مربی شخصی هوشمند شما هستم. آماده‌ای برای یک تمرین فوق‌العاده؟ بگو چه ورزشی دوست داری یا چه هدفی داری!',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _loadUserStats() {
    // شبیه‌سازی بارگذاری آمار کاربر
    streak.value = Random().nextInt(15) + 1;
    totalSessions.value = Random().nextInt(50) + 10;
  }

  Future<void> sendMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    // افزودن پیام کاربر
    messages.add(ChatMessage(
      content: prompt,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    isLoading.value = true;

    try {
      // شبیه‌سازی پاسخ AI با تاخیر واقعی
      await Future.delayed(Duration(milliseconds: 1500 + Random().nextInt(1000)));

      String aiResponse = _generateAIResponse(prompt);

      messages.add(ChatMessage(
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      ));

      // اگر کاربر درباره تمرین پرسیده، آمار رو آپدیت کن
      if (prompt.toLowerCase().contains('تمرین') ||
          prompt.toLowerCase().contains('ورزش') ||
          prompt.toLowerCase().contains('workout')) {
        totalSessions.value++;
        if (Random().nextBool()) streak.value++;
      }

    } catch (e) {
      messages.add(ChatMessage(
        content: '😔 متاسفانه مشکلی پیش اومده. لطفا دوباره تلاش کن.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
    }
  }

  String _generateAIResponse(String prompt) {
    List<String> responses = [];

    if (prompt.toLowerCase().contains('تمرین') || prompt.toLowerCase().contains('workout')) {
      responses = [
        '🔥 عالی! برای شروع، ۱۰ دقیقه گرم کردن با دویدن آهسته پیشنهاد می‌دم. بعدش ۳ ست ۱۵ تایی اسکات، ۳ ست ۱۰ تایی شنا و ۲ دقیقه پلانک. آماده‌ای؟',
        '💪 بریم برای یک تمرین قدرتی! شروع کن با ۵ دقیقه کشش، بعد ۴ ست ۱۲ تایی بارفیکس، ۳ ست ۱۵ تایی دیپ و ۳ ست ۲۰ تایی سیت‌آپ. قدرتت رو نشون بده!',
        '🏃‍♂️ امروز روز کاردیو! ۲۰ دقیقه دوی متوسط، ۱۰ دقیقه دوچرخه و ۵ دقیقه کولینگ داون. انرژیت رو آزاد کن!'
      ];
    } else if (prompt.toLowerCase().contains('غذا') || prompt.toLowerCase().contains('رژیم')) {
      responses = [
        '🥗 برای تقویت عضلات: صبحانه تخم‌مرغ + نان کامل، نهار سینه مرغ + برنج قهوه‌ای، شام ماهی + سبزیجات. فراموش نکن آب زیاد بنوشی!',
        '🍎 رژیم سالم: میوه‌های تازه، پروتئین کم چربی، غلات کامل و کلی آب. قند و چربی اضافی رو کم کن.',
        '💧 مهم‌ترین نکته: ۸-۱۰ لیوان آب در روز، پروتئین بعد از تمرین و صبحانه سنگین!'
      ];
    } else if (prompt.toLowerCase().contains('انگیزه') || prompt.toLowerCase().contains('motivation')) {
      responses = [
        '🌟 هر قدم کوچک، یک پیروزی بزرگه! تو قوی‌تر از اونی هستی که فکر می‌کنی. ادامه بده!',
        '⚡ یادت باشه هدفت! هر تمرین تو رو به رویاهات نزدیک‌تر می‌کنه. هرگز تسلیم نشو!',
        '🎯 موفقیت از تکرار کارهای کوچک می‌آد. امروز یه قدم برداری، فردا دو قدم!'
      ];
    } else {
      responses = [
        '🤔 جالبه! درباره تمرین، تغذیه یا انگیزه بیشتر بپرس. من اینجام تا کمکت کنم!',
        '💭 عالی که سوال می‌پرسی! چطوره درباره برنامه ورزشیت صحبت کنیم؟',
        '✨ من برای کمک به تناسب اندامت اینجام. چه هدفی داری؟ کاهش وزن؟ عضله‌سازی؟'
      ];
    }

    return responses[Random().nextInt(responses.length)];
  }

  void clearChat() {
    messages.clear();
    _addWelcomeMessage();
  }

  void startQuickWorkout() {
    String workouts = '''🔥 تمرین سریع ۱۵ دقیقه‌ای:

⏰ گرم کردن (۳ دقیقه):
• جامپینگ جک - ۳۰ ثانیه
• بازو چرخانی - ۳۰ ثانیه  
• زانو بالا - ۳۰ ثانیه
• کشش - ۹۰ ثانیه

💪 تمرین اصلی (۱۰ دقیقه):
• اسکات - ۳×۱۵
• شنا - ۳×۱۰
• دیپ - ۳×۸
• پلانک - ۳×۳۰ثانیه

😌 سرد کردن (۲ دقیقه):
• کشش و تنفس عمیق

بریم شروع کنیم! 🚀''';

    messages.add(ChatMessage(
      content: workouts,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    totalSessions.value++;
  }
}

// مدل پیام چت بهبود یافته
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

// صفحه اصلی بهبود یافته
class SportsPage extends StatelessWidget {
  final AIController aiController = Get.put(AIController());
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1e3c72),
              Color(0xFF2a5298),
              Color(0xFF4facfe)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildChatArea(),
              _buildQuickActions(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🏋️‍♂️ مربی من',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black26)
                  ],
                ),
              ),
              Text(
                'دستیار هوشمند ورزشی',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 12),
              RotatedBox(quarterTurns: 2,child: IconButton(onPressed: () {
                Get.back();
              }, icon: Icon(Icons.arrow_back_ios,color:Colors.white,)),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Expanded(
      flex: 4,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Obx(() {
          // Auto scroll to bottom when new message arrives
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(16),
                itemCount: aiController.messages.length,
                itemBuilder: (context, index) {
                  final msg = aiController.messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
              if (aiController.isLoading.value)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'مربی در حال تایپ...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green.withOpacity(0.8),
              child: Icon(Icons.psychology, color: Colors.white, size: 18),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: msg.isUser
                    ? Colors.blue.withOpacity(0.8)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.content,
                    style: TextStyle(
                      color: msg.isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: msg.isUser ? Colors.white70 : Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (msg.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.withOpacity(0.8),
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickActionButton('🏃‍♂️', 'تمرین سریع', () {
            aiController.startQuickWorkout();
          }),
          _buildQuickActionButton('🥗', 'تغذیه', () {
            aiController.sendMessage('برنامه غذایی مناسب بهم بده');
          }),
          _buildQuickActionButton('💪', 'قدرت', () {
            aiController.sendMessage('تمرین قدرتی برای امروز');
          }),
          _buildQuickActionButton('🧘‍♀️', 'یوگا', () {
            aiController.sendMessage('حرکات یوگا برای آرامش');
          }),
          _buildQuickActionButton('🏊‍♂️', 'کاردیو', () {
            aiController.sendMessage('تمرین کاردیو کوتاه');
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String emoji, String label, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: TextField(
                controller: inputController,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  hintText: 'سوالت رو از مربی بپرس...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.chat_bubble_outline, color: Colors.white60),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.teal.shade600],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
              ),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 24),
              onPressed: _send,
            ),
          ),
        ],
      ),
    );
  }

  void _send() {
    final text = inputController.text.trim();
    if (text.isNotEmpty) {
      inputController.clear();
      aiController.sendMessage(text);
    }
  }
}