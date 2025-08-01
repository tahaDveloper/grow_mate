import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../widget/title/title_custom.dart';

class SkillsPage extends StatefulWidget {
  @override
  _SkillsPageState createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                TitleCustom(text:  ' مهارت‌های جدید ', color: Colors.greenAccent, fontSize: 37, fontWeight: FontWeight.w800,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleCustom(text: 'راه‌های بهبود زندگی شخصی و حرفه‌ای', color: Colors.green, fontSize: 20, fontWeight: FontWeight.w800,),
                    RotatedBox(quarterTurns: 2,child:  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.red),
                    ),)
                  ],
                ),
                // Skills Cards
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildSkillCard(
                          icon: Icons.access_time,
                          title: 'مدیریت زمان',
                          description: 'یادگیری تکنیک‌های موثر برای استفاده بهینه از زمان، اولویت‌بندی کارها و افزایش بهره‌وری روزانه',
                          color: Color(0xFF4CAF50),
                          delay: 0,
                        ),
                        _buildSkillCard(
                          icon: Icons.favorite,
                          title: 'هوش هیجانی',
                          description: 'توسعه توانایی درک و کنترل احساسات خود و دیگران برای بهبود روابط و موفقیت در زندگی',
                          color: Color(0xFFE91E63),
                          delay: 200,
                        ),
                        _buildSkillCard(
                          icon: Icons.chat_bubble_outline,
                          title: 'ارتباط مؤثر',
                          description: 'تقویت مهارت‌های ارتباطی، گوش دادن فعال و بیان صحیح ایده‌ها برای موفقیت در کار و زندگی',
                          color: Color(0xFF2196F3),
                          delay: 400,
                        ),
                        _buildSkillCard(
                          icon: Icons.account_balance_wallet,
                          title: 'سواد مالی',
                          description: 'آموزش مدیریت مالی هوشمند، سرمایه‌گذاری، بودجه‌بندی و برنامه‌ریزی برای آینده مالی بهتر',
                          color: Color(0xFFFF9800),
                          delay: 600,
                        ),
                        _buildSkillCard(
                          icon: Icons.account_balance_wallet,
                          title: 'سواد دیجیتال',
                          description: 'آموزش مدیریت مالی هوشمند، سرمایه‌گذاری، بودجه‌بندی و برنامه‌ریزی برای آینده مالی بهتر',
                          color: Color(0xFFFF6991),
                          delay: 600,
                        ),
                        _buildSkillCard(
                          icon: Icons.account_balance_wallet,
                          title: 'خلاقیت و نوآوری',
                          description: 'آموزش مدیریت مالی هوشمند، سرمایه‌گذاری، بودجه‌بندی و برنامه‌ریزی برای آینده مالی بهتر',
                          color: Color(0xFFFF9889),
                          delay: 600,
                        ),
                        _buildSkillCard(
                          icon: Icons.account_balance_wallet,
                          title: 'اقتصاد',
                          description: 'آموزش مدیریت مالی هوشمند، سرمایه‌گذاری، بودجه‌بندی و برنامه‌ریزی برای آینده مالی بهتر',
                          color: Colors.teal,
                          delay: 600,
                        ),   _buildSkillCard(
                          icon: Icons.account_balance_wallet,
                          title: 'سیاست',
                          description: 'آموزش مدیریت مالی هوشمند، سرمایه‌گذاری، بودجه‌بندی و برنامه‌ریزی برای آینده مالی بهتر',
                          color: Colors.blueAccent,
                          delay: 600,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        color.withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                icon,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.6,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: color.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'شروع یادگیری',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

