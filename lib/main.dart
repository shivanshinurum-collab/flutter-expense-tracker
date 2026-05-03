import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_app/modules/home/home_controller.dart';
import 'package:expense_app/modules/theme/theme_controller.dart';
import 'package:expense_app/modules/budgets/budget_controller.dart';
import 'package:expense_app/modules/accounts/accounts_controller.dart';
import 'package:expense_app/modules/categories/categories_controller.dart';
import 'package:expense_app/modules/home/date_controller.dart';
import 'package:expense_app/modules/recurring/recurring_controller.dart';
import 'package:expense_app/modules/reminders/reminders_controller.dart';
import 'package:expense_app/modules/settings/settings_controller.dart';
import 'package:expense_app/repositories/repositories.dart';

import 'package:expense_app/modules/other/views/views.dart';

void main() async {
  // Google Fonts License
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Dependency Injection using GetX
  Get.put(SettingsController());

  Get.put(ThemeController(preferences: sharedPreferences));
  Get.put(TransactionsController());
  Get.put(BudgetController());
  Get.put(AccountsController());
  Get.put(CategoriesController());
  Get.put(DateController());
  Get.put(RecurringController());
  Get.put(RemindersController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final settingsController = Get.find<SettingsController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          home: settingsController.shouldShowOnboarding() ? const OnboardingScreen() : const MainWrapper(),
          theme: themeController.theme.value,
        ));
  }
}
