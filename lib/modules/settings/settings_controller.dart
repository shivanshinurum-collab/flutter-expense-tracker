import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxString userName = 'User'.obs;
  final RxString userProfilePath = ''.obs;
  final RxString currencySymbol = '₹'.obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    userName.value = _prefs.getString('user_name') ?? 'User';
    userProfilePath.value = _prefs.getString('user_profile_path') ?? '';
    currencySymbol.value = _prefs.getString('currency_symbol') ?? '₹';
  }

  Future<void> updateProfilePicture(String path) async {
    await _prefs.setString('user_profile_path', path);
    userProfilePath.value = path;
  }

  Future<void> updateCurrency(String symbol) async {
    await _prefs.setString('currency_symbol', symbol);
    currencySymbol.value = symbol;
  }

  Future<void> updateUserName(String name) async {
    await _prefs.setString('user_name', name);
    userName.value = name;
  }

  bool shouldShowOnboarding() {
    return _prefs.getBool('show_onboarding') ?? true;
  }

  Future<void> markOnboardingComplete() async {
    await _prefs.setBool('show_onboarding', false);
  }
}
