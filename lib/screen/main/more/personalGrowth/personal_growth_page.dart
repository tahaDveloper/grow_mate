import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../model/skill/goalModel/goal_model.dart';
import '../../../../model/skill/habitModel/habitModel.dart';
import '../../../../model/skill/journalEntryModel/JournalEntry_model.dart';




class PersonalGrowthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رشد شخصی',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0A0A23),
        cardTheme: CardTheme(
          color: const Color(0xFF1A1A3E),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A3E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A23),
              Color(0xFF1A1A3E),
              Color(0xFF2E1065),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.deepPurple],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'سفر رشد شخصی',
                                    style: Theme.of(context).textTheme.headlineLarge,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'به بهترین نسخه خودت تبدیل شو',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Main Feature Cards
                  Expanded(
                    child: Column(
                      children: [
                        // Goals Card
                        _buildFeatureCard(
                          context,
                          title: 'اهداف',
                          subtitle: 'اهداف خود را تعیین و پیگیری کنید',
                          icon: Icons.flag,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GoalsScreen()),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Habits Card
                        _buildFeatureCard(
                          context,
                          title: 'عادات مثبت',
                          subtitle: 'عادات سالم برای رشد روزانه',
                          icon: Icons.trending_up,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HabitsScreen()),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Journal Card
                        _buildFeatureCard(
                          context,
                          title: 'ژورنال نویسی',
                          subtitle: 'افکار و تجربیات خود را ثبت کنید',
                          icon: Icons.book,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFee9ca7), Color(0xFFffdde1)],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JournalScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Quote
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.format_quote,
                          color: Colors.white70,
                          size: 24,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'هر روز فرصتی جدید برای رشد و بهتر شدن است',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Gradient gradient,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Goals Screen
class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late Box<Goal> goalsBox;

  @override
  void initState() {
    super.initState();
    goalsBox = Hive.box<Goal>('goals');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اهداف من'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGoalDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A23),
              Color(0xFF1A1A3E),
              Color(0xFF2E1065),
            ],
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: goalsBox.listenable(),
          builder: (context, Box<Goal> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      size: 80,
                      color: Colors.white30,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'هنوز هدفی تعیین نکرده‌اید',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'اولین هدف خود را اضافه کنید',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                final goal = box.getAt(index)!;
                return _buildGoalCard(goal, index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: goal.isCompleted
            ? const LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)])
            : const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    goal.isCompleted ? Icons.check_circle : Icons.flag,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      goal.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: goal.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'toggle') {
                        goal.isCompleted = !goal.isCompleted;
                        goal.save();
                      } else if (value == 'delete') {
                        goalsBox.deleteAt(index);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(goal.isCompleted ? 'علامت گذاری به عنوان ناتمام' : 'علامت گذاری به عنوان تمام'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('حذف'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                goal.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      goal.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${goal.createdAt.day}/${goal.createdAt.month}/${goal.createdAt.year}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
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

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'شخصی';
    final categories = ['شخصی', 'شغلی', 'سلامتی', 'تحصیلی', 'روابط'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        title: const Text(
          'هدف جدید',
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'عنوان هدف',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'توضیحات',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                style: const TextStyle(color: Colors.white),
                dropdownColor: const Color(0xFF1A1A3E),
                decoration: const InputDecoration(
                  labelText: 'دسته‌بندی',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                items: categories.map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'لغو',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final goal = Goal(
                  title: titleController.text,
                  description: descriptionController.text,
                  createdAt: DateTime.now(),
                  category: selectedCategory,
                );
                goalsBox.add(goal);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('اضافه کردن'),
          ),
        ],
      ),
    );
  }
}

// Habits Screen
class HabitsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> predefinedHabits = [
    {'name': 'ورزش روزانه', 'description': '30 دقیقه فعالیت بدنی', 'icon': '💪'},
    {'name': 'مطالعه', 'description': 'خواندن کتاب یا مقاله', 'icon': '📚'},
    {'name': 'مدیتیشن', 'description': '10 دقیقه تمرکز و آرامش', 'icon': '🧘'},
    {'name': 'نوشیدن آب', 'description': '8 لیوان آب در روز', 'icon': '💧'},
    {'name': 'خواب به موقع', 'description': 'خوابیدن قبل از 11 شب', 'icon': '😴'},
    {'name': 'شکرگزاری', 'description': 'نوشتن 3 چیز که ممنونم', 'icon': '🙏'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عادات مثبت'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A23),
              Color(0xFF1A1A3E),
              Color(0xFF2E1065),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: predefinedHabits.length,
          itemBuilder: (context, index) {
            final habit = predefinedHabits[index];
            return _buildHabitCard(habit);
          },
        ),
      ),
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    habit['icon'],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      habit['description'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Journal Screen
class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late Box<JournalEntry> journalBox;

  @override
  void initState() {
    super.initState();
    journalBox = Hive.box<JournalEntry>('journal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ژورنال من'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEntryDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A23),
              Color(0xFF1A1A3E),
              Color(0xFF2E1065),
            ],
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: journalBox.listenable(),
          builder: (context, Box<JournalEntry> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.book_outlined,
                      size: 80,
                      color: Colors.white30,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ژورنال شما خالی است',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'اولین یادداشت خود را بنویسید',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                final entry = box.getAt(index)!;
                return _buildJournalCard(entry, index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildJournalCard(JournalEntry entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFee9ca7), Color(0xFFffdde1)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    entry.mood,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'delete') {
                        journalBox.deleteAt(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('حذف'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                entry.content,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${entry.createdAt.hour}:${entry.createdAt.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
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

  void _showAddEntryDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedMood = '😊';
    final moods = ['😊', '😢', '😡', '😴', '🤔', '😍', '😎', '🤗', '😰', '🥳'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        title: const Text(
          'یادداشت جدید',
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'عنوان',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: contentController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'محتوای یادداشت',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'حالت امروز: ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        children: moods.map((mood) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMood = mood;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedMood == mood
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selectedMood == mood
                                    ? Colors.white
                                    : Colors.white30,
                              ),
                            ),
                            child: Text(
                              mood,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'لغو',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                final entry = JournalEntry(
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: DateTime.now(),
                  mood: selectedMood,
                );
                journalBox.add(entry);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
  }
}

// Additional Hive Adapters
class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 1;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      name: fields[0] as String,
      description: fields[1] as String,
      completedDates: (fields[2] as List).cast<DateTime>(),
      icon: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.completedDates)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  bool get stringify => true;
}

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 2;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      title: fields[0] as String,
      content: fields[1] as String,
      createdAt: fields[2] as DateTime,
      mood: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.mood);
  }

  @override
  bool get stringify => true;
}