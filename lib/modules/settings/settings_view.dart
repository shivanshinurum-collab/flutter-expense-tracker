import 'package:expense_app/modules/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      final userName = settingsController.userName.value;

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Preferences',
          style: GoogleFonts.outfit(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(context, userName),
          const Divider(color: Colors.white10),
          _buildSectionHeader('Appearance'),
          _buildSettingTile('Theme (Pro version)', 'Original'),
          _buildSettingTile('UI mode', 'System default', onTap: () => _showUiModeDialog(context)),
          _buildSettingTile('Currency sign', 'Indian Rupee - INR', onTap: () => _showCurrencySignDialog(context)),
          _buildSettingTile('Currency position', 'At start of amount', onTap: () => _showCurrencyPositionDialog(context)),
          _buildSettingTile('Decimal places', '2 (eg. 10.45)', onTap: () => _showDecimalPlacesDialog(context)),
          const SizedBox(height: 16),
          _buildSectionHeader('Security'),
          _buildSettingTile('PIN lock', 'Manage app security', onTap: () => _showPinLockDialog(context)),
          const SizedBox(height: 16),
          _buildSectionHeader('Notification'),
          SwitchListTile(
            title: Text('Remind everyday', style: GoogleFonts.outfit(color: primaryColor, fontSize: 16)),
            subtitle: const Text('Remind to add expenses occasionally', style: TextStyle(color: Colors.grey, fontSize: 13)),
            value: true,
            onChanged: (val) {},
            activeColor: primaryColor,
          ),
          _buildSettingTile('Notification settings', ''),
          const SizedBox(height: 16),
          _buildSectionHeader('About'),
          SwitchListTile(
            title: Text('Send crash and usage statistics', style: GoogleFonts.outfit(color: primaryColor, fontSize: 16)),
            subtitle: const Text('Automatically send crash and usage report to improve MyMoney.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            value: true,
            onChanged: (val) {},
            activeColor: primaryColor,
          ),
          _buildSettingTile('Privacy policy', ''),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MyMoney : 6.1-free', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Developed by Ananta Raha', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const Text('contact.ananta.raha@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
    });
  }

  Widget _buildProfileHeader(BuildContext context, String name) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: primaryColor.withOpacity(0.1),
            child: Icon(Icons.person, size: 40, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => _showEditNameDialog(context, name),
                  child: Text(
                    'Edit profile',
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF4A4642),
        title: const Text('Edit Name', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await Get.find<SettingsController>().updateUserName(controller.text);
                Get.back();
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _showPinLockDialog(BuildContext context) {
    Get.snackbar(
      'Security',
      'PIN lock settings coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(color: const Color(0xFFE8E5A2).withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: GoogleFonts.outfit(color: const Color(0xFFE8E5A2), fontSize: 16)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)) : null,
    );
  }

  void _showUiModeDialog(BuildContext context) {
    _showSelectionDialog(context, 'UI mode', ['Light', 'Dark', 'System default'], 'System default');
  }

  void _showCurrencyPositionDialog(BuildContext context) {
    _showSelectionDialog(context, 'Currency position', ['At start of amount', 'At end of amount', 'Do not use currency sign'], 'At start of amount');
  }

  void _showDecimalPlacesDialog(BuildContext context) {
    _showSelectionDialog(context, 'Decimal places', ['0 (eg. 10)', '1 (eg. 10.1)', '2 (eg. 10.45)'], '2 (eg. 10.45)');
  }

  void _showCurrencySignDialog(BuildContext context) {
    final currencies = [
      'Indian Rupee - INR',
      'Indonesian Rupiah - IDR',
      'Iranian Rial - IRR',
      'Iraqi Dinar - IQD',
      'Israeli Shekel - ILS',
      'Jamaican Dollar - JMD',
      'Japanese Yen - JPY',
      'Jordanian Dinar - JOD',
      'Kazakhstani Tenge - KZT',
      'Kenyan Shilling - KES',
      'Kuwaiti Dinar - KWD',
      'Kyrgyzstani Som - KGS',
      'Laotian Kip - LAK',
    ];
    _showSelectionDialog(context, 'Currency sign', currencies, 'Indian Rupee - INR');
  }

  void _showSelectionDialog(BuildContext context, String title, List<String> options, String selectedValue) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF4A4642),
        title: Text(title, style: GoogleFonts.outfit(color: const Color(0xFFE8E5A2))),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final isSelected = options[index] == selectedValue;
              return ListTile(
                leading: Radio<bool>(
                  value: isSelected,
                  groupValue: true,
                  onChanged: (val) {},
                  activeColor: const Color(0xFFE8E5A2),
                ),
                title: Text(options[index], style: const TextStyle(color: Colors.white)),
                onTap: () => Get.back(),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL', style: TextStyle(color: Color(0xFFE8E5A2))),
          ),
        ],
      ),
    );
  }
}
