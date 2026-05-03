import 'dart:io';
import 'package:expense_app/modules/recurring/recurring_view.dart';
import 'package:expense_app/modules/reminders/reminders_view.dart';
import 'package:expense_app/modules/other/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:expense_app/modules/settings/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Get.put(_scaffoldKey);
  }

  final List<Widget> _screens = [
    MyHomePage(),
    const AnalysisPage(),
    const BudgetsPage(),
    const AccountsScreen(),
    const CategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context, theme),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Records',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Analysis',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Budgets',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Accounts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.label_outline),
            label: 'Categories',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeData theme) {
    final settingsController = Get.find<SettingsController>();

    return Drawer(
      backgroundColor: const Color(0xFF3D3935),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, bottom: 20),
            alignment: Alignment.centerLeft,
            child: Obx(() {
              final userName = settingsController.userName.value;
              final profilePath = settingsController.userProfilePath.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery);
                      if (image != null) {
                        settingsController.updateProfilePicture(image.path);
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: theme.colorScheme.primary, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.1),
                            backgroundImage: profilePath.isNotEmpty ? FileImage(
                                File(profilePath)) : null,
                            child: profilePath.isEmpty ? Icon(
                                Icons.person, color: theme.colorScheme.primary,
                                size: 35) : null,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: theme.colorScheme.primary,
                            child: const Icon(
                                Icons.edit, color: Colors.black, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => showEditNameDialog(settingsController, theme),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Hello, $userName',
                          style: GoogleFonts.outfit(
                            color: theme.colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit_outlined, color: Colors.grey,
                            size: 16),
                      ],
                    ),
                  ),
                  const Text(
                    'Professional Edition',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              );
            }),
          ),
          const Divider(color: Colors.grey, height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // _buildDrawerItem(Icons.settings_outlined, 'Preferences', onTap: () {
                //   Get.back(); // close drawer
                //   Get.to(() => const SettingsPage());
                // }),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text('Management', style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                _buildDrawerItem(
                    Icons.file_download_outlined, 'Export records', onTap: () {
                  Get.back();
                  Get.to(() => const ExportScreen());
                }),
                _buildDrawerItem(
                    Icons.autorenew, 'Recurring Transactions', onTap: () {
                  Get.back();
                  Get.to(() => const RecurringTransactionsScreen());
                }),
                _buildDrawerItem(
                    Icons.notification_important_outlined, 'Bill Reminders',
                    onTap: () {
                      Get.back();
                      Get.to(() => const RemindersScreen());
                    }),
                // _buildDrawerItem(Icons.save_outlined, 'Backup & Restore', onTap: () {
                //   Get.back();
                //   Get.to(() => const BackupScreen());
                // }),
                // _buildDrawerItem(Icons.delete_outline, 'Delete & Reset', onTap: () {
                //   Get.back();
                //   Get.to(() => const ResetScreen());
                // }),
                // const Divider(color: Colors.grey),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   child: Text('Application', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                // ),
                // _buildDrawerItem(Icons.star_outline, 'Pro version'),
                // _buildDrawerItem(Icons.thumb_up_outlined, 'Like MyMoney'),
                //const Divider(color: Colors.grey),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text('Settings', style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                Obx(() =>
                    _buildDrawerItem(
                      Icons.currency_exchange,
                      'Currency (${settingsController.currencySymbol.value})',
                      onTap: () {
                        Get.back();
                        _showCurrencySelector(settingsController);
                      },
                    )),
                _buildDrawerItem(Icons.help_outline, 'Help', onTap: () {
                  Get.back();
                  launchUrl(Uri.parse(
                      'mailto:s.kushwah9898@gmail.com?subject=MyMoney Support Request'));
                }),
                _buildDrawerItem(
                    Icons.info_outline, 'About MyMoney', onTap: () {
                  Get.back();
                  Get.to(() => const AboutPage());
                }),
                _buildDrawerItem(Icons.email_outlined, 'Feedback', onTap: () {
                  Get.back();
                  launchUrl(Uri.parse(
                      'mailto:s.kushwah9898@gmail.com?subject=MyMoney App Feedback'));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE8E5A2)),
      title: Text(
        title,
        style: GoogleFonts.outfit(color: const Color(0xFFE8E5A2), fontSize: 16),
      ),
      onTap: onTap ?? () {
        Get.back();
      },
    );
  }

  void _showCurrencySelector(SettingsController controller) {
    final List<Map<String, String>> currencies = [
      {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
      {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
      {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
      {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
      {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
      {'code': 'AED', 'symbol': 'DH', 'name': 'UAE Dirham'},
      {'code': 'SAR', 'symbol': 'SR', 'name': 'Saudi Riyal'},
      {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
      {'code': 'RUB', 'symbol': '₽', 'name': 'Russian Ruble'},
      {'code': 'KRW', 'symbol': '₩', 'name': 'South Korean Won'},
      {'code': 'IDR', 'symbol': 'Rp', 'name': 'Indonesian Rupiah'},
      {'code': 'MYR', 'symbol': 'RM', 'name': 'Malaysian Ringgit'},
      {'code': 'SGD', 'symbol': 'S\$', 'name': 'Singapore Dollar'},
      {'code': 'THB', 'symbol': '฿', 'name': 'Thai Baht'},
      {'code': 'BRL', 'symbol': 'R\$', 'name': 'Brazilian Real'},
      {'code': 'TRY', 'symbol': '₺', 'name': 'Turkish Lira'},
      {'code': 'PKR', 'symbol': '₨', 'name': 'Pakistani Rupee'},
      {'code': 'BDT', 'symbol': '৳', 'name': 'Bangladeshi Taka'},
    ];

    Get.bottomSheet(
      Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Color(0xFF3D3935),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select Currency',
                style: GoogleFonts.outfit(color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: Colors.white10),
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final cur = currencies[index];
                  final isSelected = controller.currencySymbol.value ==
                      cur['symbol'];
                  return ListTile(
                    leading: Text(cur['symbol']!, style: TextStyle(
                        color: isSelected ? const Color(0xFFE8E5A2) : Colors
                            .white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                    title: Text(cur['name']!, style: TextStyle(
                        color: isSelected ? const Color(0xFFE8E5A2) : Colors
                            .white70)),
                    trailing: isSelected ? const Icon(
                        Icons.check, color: Color(0xFFE8E5A2)) : null,
                    onTap: () {
                      controller.updateCurrency(cur['symbol']!);
                      Get.back();
                      Get.snackbar('Currency Updated',
                          'App currency changed to ${cur['name']}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black54,
                          colorText: Colors.white);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
  void showEditNameDialog(SettingsController controller, ThemeData theme) {
    final textController = TextEditingController(
        text: controller.userName.value);
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF4A4642),
        title: const Text(
            'Change Name', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.5))),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(),
              child: const Text(
                  'CANCEL', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              if (textController.text
                  .trim()
                  .isNotEmpty) {
                controller.updateUserName(textController.text.trim());
                Get.back();
              }
            },
            child: Text(
                'SAVE', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }
}
