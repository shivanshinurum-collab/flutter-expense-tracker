import 'dart:io';

import 'package:expense_app/modules/accounts/accounts_controller.dart';
import 'package:expense_app/modules/categories/categories_controller.dart';
import 'package:expense_app/modules/home/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/models/models.dart';

import '../modules/settings/settings_controller.dart';

enum NewTransactionState {
  edit,
  add,
}

class NewTransaction extends StatefulWidget {
  final NewTransactionState state;
  final Transaction transaction;

  NewTransaction.add({
    Key? key,
  })  : this.state = NewTransactionState.add,
        this.transaction = Transaction(id: "", title: "", amount: 0.0, date: DateTime.now(), createdOn: DateTime.now(), imagePath: "", category: "Others", account: "Cash"),
        super(key: key);

  NewTransaction.edit({
    Key? key,
    required this.transaction,
  })  : this.state = NewTransactionState.edit,
        super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _pickedDate = DateTime.now();
  File? _imageFile;
  String _selectedCategory = 'Food';
  String _selectedAccount = 'Cash';
  bool _isIncome = false;
  final ImagePicker _picker = ImagePicker();
  late Directory _appLibraryDirectory;

  @override
  void initState() {
    super.initState();
    _updateDirectory();

    if (widget.state == NewTransactionState.edit) {
      _titleController.text = widget.transaction.title;
      _amountController.text = widget.transaction.amount.toString();
      _pickedDate = widget.transaction.date;
      _selectedCategory = widget.transaction.category;
      _selectedAccount = widget.transaction.account;
      _isIncome = widget.transaction.isIncome;
      _dateController.text = DateFormat('MMM d, yyyy - hh:mm a').format(_pickedDate ?? DateTime.now());
      if (widget.transaction.imagePath.isNotEmpty) {
        _imageFile = File(widget.transaction.imagePath);
      }
    } else {
      _selectedCategory = _isIncome ? 'Salary' : 'Food';
    }
  }

  Future<void> _updateDirectory() async {
    _appLibraryDirectory = await getApplicationDocumentsDirectory();
  }

  void _updateImage(File image) {
    setState(() {
      _imageFile = image;
    });
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    File? writtenFile;
    if (!kIsWeb && _imageFile != null && _imageFile!.existsSync()) {
      final imageFilePath = '${_appLibraryDirectory.path}/${const Uuid().v4()}.png';
      writtenFile = await _imageFile!.copy(imageFilePath);
    }
    
    final transController = Get.find<TransactionsController>();
    final transaction = Transaction(
      id: widget.state == NewTransactionState.add
          ? const Uuid().v4()
          : widget.transaction.id,
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: _pickedDate ?? DateTime.now(),
      imagePath: writtenFile?.path ?? (widget.state == NewTransactionState.edit ? widget.transaction.id != "" ? widget.transaction.imagePath : "" : ''),
      createdOn: DateTime.now(),
      category: _selectedCategory,
      account: _selectedAccount,
      isIncome: _isIncome,
    );
    if (_selectedCategory == 'Category' || _selectedCategory.isEmpty) {
      Get.snackbar('Error', 'Please select a category', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_selectedAccount == 'Account' || _selectedAccount.isEmpty) {
      Get.snackbar('Error', 'Please select an account', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (widget.state == NewTransactionState.add) {
      transController.addTransaction(transaction);
      // Update account balance
      Get.find<AccountsController>().updateAccountBalance(_selectedAccount, double.parse(_amountController.text), _isIncome);
    } else {
      transController.updateTransaction(transaction);
    }
    Get.back();
  }

  void _startDateTimePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
        initialTime: TimeOfDay.fromDateTime(_pickedDate ?? DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _pickedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          _dateController.text = DateFormat('MMM d, yyyy - hh:mm a').format(_pickedDate!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesController = Get.find<CategoriesController>();
    final accountsController = Get.find<AccountsController>();
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Expense'), icon: Icon(Icons.remove_circle_outline)),
                    ButtonSegment(value: true, label: Text('Income'), icon: Icon(Icons.add_circle_outline)),
                  ],
                  selected: {_isIncome},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _isIncome = newSelection.first;
                      _selectedCategory = _isIncome ? 'Salary' : 'Food';
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Category Selection
              Text('Category', style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              Obx(() {
                final categories = categoriesController.categories;
                final filtered = categories.where((c) => c.isIncome == _isIncome).toList();
                return SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final cat = filtered[index];
                      final isSelected = _selectedCategory == cat.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat.name),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(cat.name, style: TextStyle(
                              color: isSelected ? Colors.black : theme.colorScheme.primary,
                              fontWeight: FontWeight.bold
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Account Selection
              Text('Account', style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              Obx(() {
                final accounts = accountsController.accounts;
                return SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: accounts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final acc = accounts[index];
                      final isSelected = _selectedAccount == acc.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAccount = acc.name),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(acc.name, style: TextStyle(
                              color: isSelected ? Colors.black : theme.colorScheme.primary,
                              fontWeight: FontWeight.bold
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: '${Get.find<SettingsController>().currencySymbol.value} ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter amount';
                        if (double.tryParse(val) == null) return 'Enter a number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: _startDateTimePicker,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 20, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Icon(Icons.access_time, size: 20, color: theme.colorScheme.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Date & Time: ${_dateController.text.isEmpty ? 'Not selected' : _dateController.text}',
                style: TextStyle(color: theme.colorScheme.primary.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Attachment
              Row(
                children: [
                  Text('Receipt', style: theme.textTheme.titleSmall),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) _updateImage(File(image.path));
                    },
                    icon: const Icon(Icons.image_outlined),
                  ),
                  IconButton(
                    onPressed: () async {
                      final image = await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) _updateImage(File(image.path));
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ],
              ),
              if (_imageFile != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => setState(() => _imageFile = null),
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Icon(Icons.close, size: 16, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('SAVE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
