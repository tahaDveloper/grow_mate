import 'package:get/get.dart';

class PersonalityController extends GetxController {
  var answers = <int>[].obs; // لیست پاسخ‌ها (0 تا 3 برای هر سوال)
  var currentQuestionIndex = 0.obs; // شماره سوال فعلی


  final List<String> options1 = [
    "ترجیح می‌دم تنها باشم و مطالعه کنم.",
    "دوست دارم با دیگران وقت بگذرونم.",
    "اهل ماجراجویی و تجربه‌های جدیدم.",
    "بیشتر محتاط و آرام هستم.",
  ];

  final List<String> options2 = [
    "دوست دارم برنامه‌ریزی کنم و همه چیز منظم باشه.",
    "ترجیح می‌دم کارها رو بدون برنامه پیش ببرم.",
    "عاشق کشف چیزهای جدیدم.",
    "بیشتر به چیزهای آشنا علاقه دارم.",
  ];
  final List<String> options3 = [
    "بیشتر به جزئیات دقت می‌کنم.",
    "دوست دارم کلیات رو ببینم و سریع تصمیم بگیرم.",
    "همیشه دنبال ایده‌های جدیدم.",
    "ترجیح می‌دم روی چیزهای ثابت و مطمئن تمرکز کنم.",
  ];
  final List<String> options4 = [
    "بیشتر روی گذشته و تجربه‌ها تمرکز می‌کنم.",
    "به آینده و احتمالات فکر می‌کنم.",
    "دوست دارم ریسک کنم و شانس خودم رو امتحان کنم.",
    "ترجیح می‌دم محتاط باشم و ریسک نکنم.",
  ];
  final List<String> options5 = [
    "دوست دارم تنها کار کنم و تمرکز داشته باشم.",
    "ترجیح می‌دم تیمی کار کنم و با دیگران همکاری کنم.",
    "همیشه دنبال چالش‌های جدیدم.",
    "بیشتر دنبال ثبات و آرامشم.",
  ];
  void saveAnswer(int answer) {
    if (answers.length <= currentQuestionIndex.value) {
      answers.add(answer);
    } else {
      answers[currentQuestionIndex.value] = answer;
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < 4) {
      currentQuestionIndex.value++;
      Get.toNamed('/personality${currentQuestionIndex.value + 1}');
    } else {
      Get.toNamed('/result');
    }
  }

  void reset() {
    answers.clear();
    currentQuestionIndex.value = 0;
  }

  String calculatePersonality() {
    int introvert = 0, extrovert = 0, adventurer = 0, calm = 0;

    for (int answer in answers) {
      switch (answer) {
        case 0:
          introvert++;
          break;
        case 1:
          extrovert++;
          break;
        case 2:
          adventurer++;
          break;
        case 3:
          calm++;
          break;
      }
    }

    int maxScore = [introvert, extrovert, adventurer, calm].reduce((a, b) => a > b ? a : b);
    if (maxScore == introvert) return "درون‌گرا و تحلیل‌گر";
    if (maxScore == extrovert) return "برون‌گرا و اجتماعی";
    if (maxScore == adventurer) return "جستجوگر و ماجراجو";
    return "منظم و آرام‌گرا";
  }
}