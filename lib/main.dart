import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:grow_mate/screen/dashbord/dashbord.dart';
import 'package:grow_mate/screen/intro/splash_page.dart';
import 'package:grow_mate/screen/main/RewardScreen/profile_screen.dart';
import 'package:grow_mate/screen/main/dailyTask/addFolder.dart';
import 'package:grow_mate/screen/main/dailyTask/daily_task.dart';
import 'package:grow_mate/screen/main/dailyTask/detail_daily_tasks.dart';
import 'package:grow_mate/screen/main/financialAdvisor/consulting/consulting_screen.dart';
import 'package:grow_mate/screen/main/financialAdvisor/expenseTracker/expense_tracker_page.dart';
import 'package:grow_mate/screen/main/financialAdvisor/financial_advisor.dart';
import 'package:grow_mate/screen/main/more/image/AIImage_generator_screen.dart';
import 'package:grow_mate/screen/main/more/more_page.dart';
import 'package:grow_mate/screen/main/more/newSkill/newSkill_page.dart';
import 'package:grow_mate/screen/main/more/personalGrowth/personal_growth_page.dart';
import 'package:grow_mate/screen/main/more/sport/sport_page.dart';
import 'package:grow_mate/screen/main/more/therapist/therapist_page.dart';
import 'package:grow_mate/screen/main/personality/questions/PersonalityScreen2.dart';
import 'package:grow_mate/screen/main/personality/questions/PersonalityScreen3.dart';
import 'package:grow_mate/screen/main/personality/questions/PersonalityScreen4.dart';
import 'package:grow_mate/screen/main/personality/questions/PersonalityScreen5.dart';
import 'package:grow_mate/screen/main/personality/questions/personality_screen1.dart';
import 'package:grow_mate/screen/main/personality/result_screen.dart';
import 'package:grow_mate/service/localizition/LocaleString.dart';
import 'package:grow_mate/service/localizition/fa.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'model/skill/goalModel/goal_model.dart';
import 'model/skill/habitModel/habitModel.dart';
import 'model/taskModel/addTask/add_task_model.dart';
import 'model/taskModel/task_model.dart';
import 'model/transaction/transaction.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());

  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(CategoryAdapter());

  Hive.registerAdapter(FolderItemAdapter());



  await Hive.openBox<Task>('tasks');
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<FolderItem>('FolderItem');

  await Hive.openBox<Goal>('goals');
  await Hive.openBox<Habit>('habits');

  runApp(
      GetMaterialApp(

        locale: Locale('fa', 'IR'),
        translations: LocaleString(faLanguage: PersianLanguage()),

        initialRoute:'/DashboardPage' ,
        getPages: [
          //intro
          GetPage(name: '/SplashPage', page: () => const SplashPage(),),
          GetPage(name: '/SplashPage2', page: () => const SplashPage2(),),

          ///Dashboard
          GetPage(name: '/DashboardPage', page: () => const DashboardPage(),),

          //questions
          GetPage(name: '/PersonalityScreen1', page: () => const PersonalityScreen1(),),
          GetPage(name: '/PersonalityScreen2', page: () => const PersonalityScreen2(),),
          GetPage(name: '/PersonalityScreen3', page: () => const PersonalityScreen3(),),
          GetPage(name: '/PersonalityScreen4', page: () => const PersonalityScreen4(),),
          GetPage(name: '/PersonalityScreen5', page: () => const PersonalityScreen5(),),

          //main_page
          GetPage(name: '/ResultScreen', page: () => const ResultScreen(),),

          ///profile
          GetPage(name: '/RewardScreen', page: () => const ProfileScreen(),),


          ///Task
          GetPage(name: '/DailyTasksScreen', page: () => const DailyTasksScreen(),),
          GetPage(name: '/DetailDailyTasksScreen', page: () => const DetailDailyTasksScreen(),),
          GetPage(name: '/AddFolderScreen', page: () => const AddFolderScreen(),),

          ///finance
          GetPage(name: '/FinancialAdvisorScreen', page: () =>  const FinancialAdvisorScreen(),),
          GetPage(name: '/ExpenseTrackerScreen', page: () => const ExpenseTrackerScreen(),),
          GetPage(name: '/ConsultingScreen', page: () => const ConsultingScreen(),),

          ///more
          GetPage(name: '/MoreScreen', page: () =>  MoreScreen(),),
          GetPage(name: '/SportsPage', page: () =>  SportsPage(),),
          GetPage(name: '/TherapistPage', page: () =>  TherapistPage(),),
          GetPage(name: '/AIImageGeneratorScreen', page: () =>  AIImageGeneratorScreen(),),
          GetPage(name: '/PersonalGrowthApp', page: () =>  PersonalGrowthApp(),),
          GetPage(name: '/SkillsPage', page: () =>  SkillsPage(),),

        ],
      )
  );
}