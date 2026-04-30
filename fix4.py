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

# developer.dart
rep('lib/screens/developer.dart', r'FaIconData', r'IconData')

# dev_link.dart
rep('lib/widgets/dev_link.dart', r'FaIcon\(icon as dynamic, color: Colors\.white\)', r'FaIcon(icon, color: Colors.white)')
rep('lib/widgets/dev_link.dart', r'FaIcon\(icon as IconData, color: Colors\.white\)', r'FaIcon(icon, color: Colors.white)')

# new_transaction.dart
rep('lib/widgets/new_transaction.dart', r'DateTime\? _pickedDate;', r'DateTime? _pickedDate = DateTime.now();')
rep('lib/widgets/new_transaction.dart', r'_dateController\.text = DateFormat\.yMMMd\(\)\.format\(_pickedDate\);', r'_dateController.text = DateFormat.yMMMd().format(_pickedDate ?? DateTime.now());')
rep('lib/widgets/new_transaction.dart', r'widget\.transaction\.imagePath\.isNotEmpty', r'(widget.transaction.imagePath != null && widget.transaction.imagePath!.isNotEmpty)')
rep('lib/widgets/new_transaction.dart', r'File\(widget\.transaction\.imagePath\)', r'File(widget.transaction.imagePath!)')
rep('lib/widgets/new_transaction.dart', r'!_formKey\.currentState\.validate\(\)', r'!_formKey.currentState!.validate()')
rep('lib/widgets/new_transaction.dart', r'date: _pickedDate,', r'date: _pickedDate ?? DateTime.now(),')
rep('lib/widgets/new_transaction.dart', r'imagePath: _imageFile == null \? \'\' : writtenFile\.path,', r'imagePath: _imageFile == null ? \'\' : (writtenFile?.path ?? \'\'),')
rep('lib/widgets/new_transaction.dart', r'value\.isEmpty', r'(value == null || value.isEmpty)')

# transaction_list.dart
rep('lib/widgets/transaction_list.dart', r'List<Transaction> transactions;', r'List<Transaction>? transactions;')
rep('lib/widgets/transaction_list.dart', r'Function deleteTransaction;', r'Function? deleteTransaction;')

# transaction.dart
rep('lib/models/transaction.dart', r'this\.amount,', r'required this.amount,')

# week_bar_chart.dart
rep('lib/widgets/week_bar_chart.dart', r'Theme\.of\(context\)\.colorScheme\.secondary', r'Theme.of(context).colorScheme.secondary')
rep('lib/widgets/week_bar_chart.dart', r'ThemeData', r'ThemeData')
rep('lib/widgets/week_bar_chart.dart', r'accentColor', r'colorScheme.secondary')
rep('lib/widgets/week_bar_chart.dart', r'return null;', r'return _makeGroupData(6, 0);')
rep('lib/widgets/week_bar_chart.dart', r'String weekDay;', r'String weekDay = \"\";')

