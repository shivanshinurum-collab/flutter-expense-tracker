import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/extensions/extensions.dart';
import 'package:expense_app/models/models.dart';

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
        this.transaction = Transaction(id: "", title: "", amount: 0.0, date: DateTime.now(), createdOn: DateTime.now(), imagePath: ""),
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
  bool _isIncome = false;
  final ImagePicker _picker = ImagePicker();
  late Directory _appLibraryDirectory;

  final List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.pink},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.purple},
    {'name': 'Health', 'icon': Icons.medical_services, 'color': Colors.red},
    {'name': 'Others', 'icon': Icons.category, 'color': Colors.blueGrey},
  ];

  final List<Map<String, dynamic>> _incomeCategories = [
    {'name': 'Salary', 'icon': Icons.payments, 'color': Colors.green},
    {'name': 'Gift', 'icon': Icons.card_giftcard, 'color': Colors.orange},
    {'name': 'Interest', 'icon': Icons.trending_up, 'color': Colors.blue},
    {'name': 'Others', 'icon': Icons.category, 'color': Colors.blueGrey},
  ];

  @override
  void initState() {
    super.initState();
    _updateDirectory();

    if (widget.state == NewTransactionState.edit) {
      _titleController.text = widget.transaction.title;
      _amountController.text = widget.transaction.amount.toString();
      _pickedDate = widget.transaction.date;
      _selectedCategory = widget.transaction.category;
      _isIncome = widget.transaction.isIncome;
      _dateController.text = DateFormat.yMMMd().format(_pickedDate ?? DateTime.now());
      if (widget.transaction.imagePath.isNotEmpty) {
        _imageFile = File(widget.transaction.imagePath);
      }
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
    if (_imageFile != null && _imageFile!.existsSync()) {
      final imageFilePath = '${_appLibraryDirectory.path}/${Uuid().v4()}.png';
      writtenFile = await _imageFile!.copy(imageFilePath);
    }
    final tBloc = context.read<TransactionsBloc>();
    final transaction = Transaction(
      id: widget.state == NewTransactionState.add
          ? const Uuid().v4()
          : widget.transaction.id,
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: _pickedDate ?? DateTime.now(),
      imagePath: writtenFile?.path ?? (widget.state == NewTransactionState.edit ? widget.transaction.imagePath : ''),
      createdOn: DateTime.now(),
      category: _selectedCategory,
      isIncome: _isIncome,
    );
    if (widget.state == NewTransactionState.add) {
      tBloc.add(AddTransaction(transaction: transaction));
    } else {
      tBloc.add(UpdateTransaction(transaction: transaction));
    }
    Navigator.of(context).pop();
  }

  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _pickedDate = value;
          _dateController.text = DateFormat.yMMMd().format(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
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
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: _isIncome ? Colors.green : theme.colorScheme.primary,
                    selectedForegroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                widget.state == NewTransactionState.add 
                  ? (_isIncome ? 'New Income' : 'New Expense') 
                  : (_isIncome ? 'Edit Income' : 'Edit Expense'),
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Category Selection
              Text('Category', style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _isIncome ? _incomeCategories.length : _expenseCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final categories = _isIncome ? _incomeCategories : _expenseCategories;
                    final cat = categories[index];
                    final isSelected = _selectedCategory == cat['name'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat['name']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? cat['color'] : cat['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(cat['icon'], size: 18, color: isSelected ? Colors.white : cat['color']),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Text(cat['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: _isIncome ? 'Where did this income come from?' : 'What did you spend on?',
                  hintText: _isIncome ? 'e.g. Freelance project' : 'e.g. Dinner with friends',
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
                        prefixText: '₹ ',
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
                      onTap: _startDatePicker,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ],
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
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.state == NewTransactionState.add 
                      ? (_isIncome ? 'Save Income' : 'Save Expense') 
                      : (_isIncome ? 'Update Income' : 'Update Expense'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
