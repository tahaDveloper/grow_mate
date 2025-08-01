import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grow_mate/util/color.dart';
import '../main/RewardScreen/profile_screen.dart';
import '../main/dailyTask/daily_task.dart';
import '../main/financialAdvisor/financial_advisor.dart';
import '../main/more/more_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static final List<Widget> _widgetOptions = <Widget>[
    const DailyTasksScreen(),
     FinancialAdvisorScreen(),
    const ProfileScreen(),
    MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            height: 65,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black, // رنگ پس‌زمینه
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/image/perspective_matte-128x128.png",
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: const Icon(Icons.task_alt, color: Colors.lightBlueAccent, size: 20),
                  label: "Task's",
                ),

                 BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/image/perspective_matte-376-128x128.png",
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: Icon(Icons.attach_money_outlined, color: Colors.amber, size: 20),
                  label: 'finance',
                ),
                 BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/image/profile.png",
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: const Icon(Icons.person_outline_outlined, color: Colors.red, size: 20),
                  label: 'profile',
                ),
                 BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/image/more.png",
                    width: 25,
                    height: 25,
                  ),
                  activeIcon: const Icon(Icons.expand_more, color: Colors.green, size: 20),
                  label: "skill",
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.greenAccent,
              unselectedItemColor: Colors.white70,
              backgroundColor: Colors.transparent, // پس‌زمینه شفاف برای نمایش Container
              elevation: 0, // حذف سایه پیش‌فرض BottomNavigationBar
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              unselectedFontSize: 12, // اصلاح مقدار unselectedFontSize
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),

    );
  }
}

