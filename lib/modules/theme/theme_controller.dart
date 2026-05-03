import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeColor {
  red,
  purple,
  blue,
  green,
  indigo,
  teal,
  myMoney,
}

ThemeData _createTheme(Color seedColor, {bool isDark = false}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    textTheme: isDark
        ? GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

final purpleTheme = _createTheme(const Color(0xFF8B5CF6));
final greenTheme = _createTheme(const Color(0xFF10B981));
final redTheme = _createTheme(const Color(0xFFEF4444));
final blueTheme = _createTheme(const Color(0xFF3B82F6));
final indigoTheme = _createTheme(const Color(0xFF6366F1));
final tealTheme = _createTheme(const Color(0xFF004D40));
final darkTheme = _createTheme(const Color(0xFF6366F1), isDark: true);

final myMoneyTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF3D3935),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFE8E5A2),
    secondary: Color(0xFF4D4944),
    surface: Color(0xFF3D3935),
    onSurface: Color(0xFFE8E5A2),
    onPrimary: Color(0xFF3D3935),
  ),
  textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
    bodyColor: const Color(0xFFE8E5A2),
    displayColor: const Color(0xFFE8E5A2),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF3D3935),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.outfit(
      color: const Color(0xFFE8E5A2),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE8E5A2)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF3D3935),
    selectedItemColor: Color(0xFFE8E5A2),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4D4944),
    foregroundColor: Color(0xFFE8E5A2),
  ),
);

class ThemeController extends GetxController {
  final SharedPreferences _preferences;

  ThemeController({required SharedPreferences preferences})
      : _preferences = preferences;

  final Rx<ThemeColor> color = ThemeColor.myMoney.obs;
  final Rx<ThemeData> theme = myMoneyTheme.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeIfPresent();
  }

  void toRed() {
    color.value = ThemeColor.red;
    theme.value = redTheme;
    Get.changeTheme(redTheme);
    saveTheme(ThemeColor.red);
  }

  void toPurple() {
    color.value = ThemeColor.purple;
    theme.value = purpleTheme;
    Get.changeTheme(purpleTheme);
    saveTheme(ThemeColor.purple);
  }

  void toBlue() {
    color.value = ThemeColor.blue;
    theme.value = blueTheme;
    Get.changeTheme(blueTheme);
    saveTheme(ThemeColor.blue);
  }

  void toGreen() {
    color.value = ThemeColor.green;
    theme.value = greenTheme;
    Get.changeTheme(greenTheme);
    saveTheme(ThemeColor.green);
  }

  void toTeal() {
    color.value = ThemeColor.teal;
    theme.value = tealTheme;
    Get.changeTheme(tealTheme);
    saveTheme(ThemeColor.teal);
  }

  void toIndigo() {
    color.value = ThemeColor.indigo;
    theme.value = indigoTheme;
    Get.changeTheme(indigoTheme);
    saveTheme(ThemeColor.indigo);
  }

  void toMyMoney() {
    color.value = ThemeColor.myMoney;
    theme.value = myMoneyTheme;
    Get.changeTheme(myMoneyTheme);
    saveTheme(ThemeColor.myMoney);
  }

  void loadThemeIfPresent() {
    final savedTheme = _preferences.getString('theme');
    if (savedTheme != null) {
      try {
        ThemeColor colorValue = ThemeColor.values
            .firstWhere((element) => element.toString() == savedTheme);
        switch (colorValue) {
          case ThemeColor.blue:
            toBlue();
            break;
          case ThemeColor.purple:
            toPurple();
            break;
          case ThemeColor.green:
            toGreen();
            break;
          case ThemeColor.red:
            toRed();
            break;
          case ThemeColor.indigo:
            toIndigo();
            break;
          case ThemeColor.teal:
            toTeal();
            break;
          case ThemeColor.myMoney:
            toMyMoney();
            break;
        }
      } catch (e) {
        toTeal();
      }
    }
  }

  void saveTheme(ThemeColor colorValue) {
    _preferences.setString('theme', colorValue.toString());
  }
}
