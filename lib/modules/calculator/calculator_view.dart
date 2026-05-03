import 'package:expense_app/modules/accounts/accounts_controller.dart';
import 'package:expense_app/modules/categories/categories_controller.dart';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:expense_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/modules/accounts/accounts_view.dart';
import 'package:expense_app/modules/categories/categories_view.dart';

class CalculatorInputPage extends StatefulWidget {
  final Transaction? editTransaction;
  const CalculatorInputPage({Key? key, this.editTransaction}) : super(key: key);

  @override
  State<CalculatorInputPage> createState() => _CalculatorInputPageState();
}

class _CalculatorInputPageState extends State<CalculatorInputPage> {
  String _amount = "0";
  String _notes = "";
  String _selectedCategory = "Category";
  String _selectedAccount = "Account";
  String _type = "EXPENSE"; // INCOME, EXPENSE, TRANSFER
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.editTransaction != null) {
      _amount = widget.editTransaction!.amount.toString();
      _selectedCategory = widget.editTransaction!.category;
      _selectedAccount = widget.editTransaction!.account;
      _type = widget.editTransaction!.isIncome ? "INCOME" : "EXPENSE";
      _selectedDate = widget.editTransaction!.date;
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == "⌫") {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = "0";
        }
      } else if (key == ".") {
        if (!_amount.contains(".")) {
          _amount += ".";
        }
      } else {
        if (_amount == "0") {
          _amount = key;
        } else {
          _amount += key;
        }
      }
    });
  }

  void _onSave() {
    final amountValue = double.tryParse(_amount) ?? 0.0;
    if (amountValue <= 0) return;

    if (_selectedCategory == "Category") {
      Get.snackbar('Error', 'Please select a category', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_selectedAccount == "Account") {
      Get.snackbar('Error', 'Please select an account', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final transaction = Transaction(
      id: widget.editTransaction?.id ?? const Uuid().v4(),
      title: _notes.isEmpty ? _selectedCategory : _notes,
      amount: amountValue,
      date: _selectedDate,
      createdOn: DateTime.now(),
      imagePath: "",
      category: _selectedCategory,
      account: _selectedAccount,
      isIncome: _type == "INCOME",
    );

    final transController = Get.find<TransactionsController>();
    if (widget.editTransaction == null) {
      transController.addTransaction(transaction);
    } else {
      transController.updateTransaction(transaction);
    }
    Get.back();
  }

  void _showDateTimePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('✕ CANCEL', style: GoogleFonts.outfit(color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: _onSave,
                    child: Text('✓ SAVE', style: GoogleFonts.outfit(color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            // Type Toggle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTypeTab("INCOME"),
                  const Text("  |  ", style: TextStyle(color: Colors.grey)),
                  _buildTypeTab("EXPENSE"),
                  const Text("  |  ", style: TextStyle(color: Colors.grey)),
                  _buildTypeTab("TRANSFER"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Selectors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildSelector(Icons.account_balance_wallet_outlined, _selectedAccount, isAccount: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSelector(Icons.label_outline, _selectedCategory, isAccount: false)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Notes Field
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (val) => _notes = val,
                maxLines: null,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Add notes',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            // Display Area
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  _amount,
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            // Calculator Keypad
            _buildKeypad(),
            // Date and Time
            GestureDetector(
              onTap: _showDateTimePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFFE8E5A2), size: 16),
                        const SizedBox(width: 8),
                        Text(DateFormat('MMM dd, yyyy').format(_selectedDate), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const Text("|", style: TextStyle(color: Colors.grey)),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFFE8E5A2), size: 16),
                        const SizedBox(width: 8),
                        Text(DateFormat('hh:mm a').format(_selectedDate), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTab(String type) {
    final selected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Row(
        children: [
          if (selected) const Icon(Icons.check_circle, color: Colors.white, size: 16),
          if (selected) const SizedBox(width: 4),
          Text(
            type,
            style: GoogleFonts.outfit(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelector(IconData icon, String label, {bool isAccount = true}) {
    return GestureDetector(
      onTap: () {
        if (isAccount) {
          _showAccountSelection();
        } else {
          _showCategorySelection();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: (isAccount ? _selectedAccount == "Account" : _selectedCategory == "Category") ? Colors.red.withOpacity(0.5) : Colors.grey.shade700),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE8E5A2)),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  void _showAccountSelection() {
    final accounts = Get.find<AccountsController>().accounts;
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF3D3935),
        title: Text('Select Account', style: GoogleFonts.outfit(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(accounts[index].name, style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        setState(() => _selectedAccount = accounts[index].name);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
              const Divider(color: Colors.grey),
              const Text('MANAGE ACCOUNTS', style: TextStyle(color: Color(0xFFE8E5A2))),
              // TextButton(
              //   onPressed: () {
              //     Get.back();
              //     Get.to(() => const AccountsScreen());
              //   },
              //   child: const Text('MANAGE ACCOUNTS', style: TextStyle(color: Color(0xFFE8E5A2))),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategorySelection() {
    final categories = Get.find<CategoriesController>().categories.where((c) => c.isIncome == (_type == "INCOME")).toList();
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF3D3935),
        title: Text('Select Category', style: GoogleFonts.outfit(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(categories[index].name, style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        setState(() => _selectedCategory = categories[index].name);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
              const Divider(color: Colors.grey),
              const Text('CATEGORIES', style: TextStyle(color: Color(0xFFE8E5A2))),
              // TextButton(
              //   onPressed: () {
              //     Get.back();
              //     Get.to(() => const CategoriesScreen());
              //   },
              //   child: const Text('CATEGORIES', style: TextStyle(color: Color(0xFFE8E5A2))),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ["+", "7", "8", "9"],
      ["-", "4", "5", "6"],
      ["*", "1", "2", "3"],
      ["/", "0", ".", "⌫"],
    ];

    return Container(
      color: const Color(0xFF4A4642),
      child: Column(
        children: keys.map((row) {
          return Row(
            children: row.map((key) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onKeyPress(key),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade800, width: 0.5),
                      color: ["+", "-", "*", "/", "⌫"].contains(key) ? const Color(0xFF3D3935) : null,
                    ),
                    child: Center(
                      child: Text(
                        key,
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
