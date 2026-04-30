import os
import re

def rep(p, s, r):
    try:
        with open(p, 'r', encoding='utf-8') as f:
            c = f.read()
        c = re.sub(s, r, c)
        with open(p, 'w', encoding='utf-8') as f:
            f.write(c)
    except Exception as e:
        print(f"Failed {p}: {e}")

# analysis_options.yaml
rep('analysis_options.yaml', r'include: package:flutter_lints/flutter.yaml', r'# include: package:flutter_lints/flutter.yaml')

# new_transaction.dart
rep('lib/widgets/new_transaction.dart', r'this\.transaction = null,', r'/* this.transaction = null */')
rep('lib/widgets/new_transaction.dart', r'late TextEditingController _controller;', r'late GalleryController _controller;')
rep('lib/widgets/new_transaction.dart', r'final file = await list\[0\]\.entity\.file;', r'final file = await list[0].entity.file;')
rep('lib/widgets/new_transaction.dart', r'_updateImage\(file\);', r'_updateImage(file!);')
rep('lib/widgets/new_transaction.dart', r'DateTime\? _pickedDate;', r'DateTime? _pickedDate = DateTime.now();')
rep('lib/widgets/new_transaction.dart', r'// _imageFile = null;', r'_imageFile = null;')
rep('lib/widgets/new_transaction.dart', r'File\? _imageFile = null;', r'File? _imageFile;')
rep('lib/widgets/new_transaction.dart', r'File writtenFile;', r'late File writtenFile;')
rep('lib/widgets/new_transaction.dart', r'_imageFile\.readAsBytesSync\(\)', r'_imageFile!.readAsBytesSync()')
rep('lib/widgets/new_transaction.dart', r'_formKey\.currentState\.validate\(\)', r'_formKey.currentState!.validate()')
rep('lib/widgets/new_transaction.dart', r'widget\.transaction\.imagePath\.isNotEmpty', r'(widget.transaction?.imagePath?.isNotEmpty ?? false)')
rep('lib/widgets/new_transaction.dart', r'widget\.transaction\.title', r'widget.transaction?.title ?? \"\"')
rep('lib/widgets/new_transaction.dart', r'widget\.transaction\.amount\.toString\(\)', r'widget.transaction?.amount.toString() ?? \"0\"')
rep('lib/widgets/new_transaction.dart', r'widget\.transaction\.date', r'widget.transaction?.date ?? DateTime.now()')
rep('lib/widgets/new_transaction.dart', r'widget\.transaction\.id', r'widget.transaction?.id ?? \"\"')
rep('lib/widgets/new_transaction.dart', r'DateFormat\.yMMMd\(\)\.format\(_pickedDate\)', r'DateFormat.yMMMd().format(_pickedDate!)')
rep('lib/widgets/new_transaction.dart', r'TextButton\([\s\S]*?color: Theme.of\(context\)\.primaryColor,[\s\S]*?shape: RoundedRectangleBorder\([\s\S]*?borderRadius: BorderRadius\.circular\(18\),[\s\S]*?\),[\s\S]*?padding: EdgeInsets\.symmetric\([\s\S]*?horizontal: 20,[\s\S]*?vertical: 10,[\s\S]*?\),[\s\S]*?\)', r'''TextButton(
                      onPressed: _onSubmit,
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        widget.state == NewTransactionState.add
                            ? 'Add Transaction'
                            : 'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    )''')
rep('lib/widgets/new_transaction.dart', r'TextButton\(', r'TextButton(')
rep('lib/widgets/new_transaction.dart', r'Image\.file\(_imageFile\)', r'_imageFile != null ? Image.file(_imageFile!) : Container()')

# week_bar_chart.dart
rep('lib/widgets/week_bar_chart.dart', r'List<Transaction> _transactions;', r'List<Transaction>? _transactions;')
rep('lib/widgets/week_bar_chart.dart', r'int _touchedIndex;', r'int _touchedIndex = -1;')
rep('lib/widgets/week_bar_chart.dart', r'double _total;', r'double _total = 0.0;')
rep('lib/widgets/week_bar_chart.dart', r'widget\._transactions\.isEmpty', r'(widget._transactions == null || widget._transactions!.isEmpty)')
rep('lib/widgets/week_bar_chart.dart', r'for \(Transaction transaction in widget\._transactions\)', r'for (Transaction transaction in widget._transactions!)')
rep('lib/widgets/week_bar_chart.dart', r'return null;', r'return _makeGroupData(6, 0);')
rep('lib/widgets/week_bar_chart.dart', r'String weekDay;', r'String weekDay = \"\";')
rep('lib/widgets/week_bar_chart.dart', r'barTouchResponse\.spot\.touchedBarGroupIndex', r'barTouchResponse.spot!.touchedBarGroupIndex')
rep('lib/widgets/week_bar_chart.dart', r'List<Transaction>\? transactions', r'List<Transaction>? transactions = const []')
rep('lib/widgets/week_bar_chart.dart', r'widget\._transactions = transactions;', r'')

# week_pie_chart.dart
rep('lib/widgets/week_pie_chart.dart', r'List<Transaction> transactions', r'List<Transaction>? transactions = const []')

# developer.dart
rep('lib/screens/developer.dart', r'FaIconData', r'IconData')

# transactions_state.dart
rep('lib/blocs/transactions/transactions_state.dart', r'status \?\? this\.status,', r'status: status ?? this.status,')
rep('lib/blocs/transactions/transactions_state.dart', r'TransactionsStatus\? status,', r'TransactionsStatus? status = TransactionsStatus.initial,')

# models/transaction.dart
rep('lib/models/transaction.dart', r'String\? amount,', r'double? amount,')

# home.dart
rep('lib/screens/home.dart', r'\(max \?\? 0\) > 0', r'(max ?? 0) > 0')

# transaction_list.dart
rep('lib/widgets/transaction_list.dart', r'List<Transaction>\? transactions', r'List<Transaction>? transactions = const []')
rep('lib/widgets/transaction_list.dart', r'Function\? deleteTransaction', r'Function? deleteTransaction = null')

# settings.dart
rep('lib/screens/settings.dart', r'canLaunchUrl\(Uri\.parse\(url\)\)', r'canLaunchUrl(Uri.parse(url))')

# details_title.dart
rep('lib/widgets/details_title.dart', r'Theme\.of\(context\)\.textTheme\.headlineMedium\?\.apply', r'Theme.of(context).textTheme.headlineMedium!.apply')
