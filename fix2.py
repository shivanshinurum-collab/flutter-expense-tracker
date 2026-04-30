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

rep('lib/blocs/app_bloc_observer.dart', r'void onEvent\(Bloc bloc, Object event\)', r'void onEvent(Bloc bloc, Object? event)')

rep('lib/widgets/details_title.dart', r'\.apply\(', r'?.apply(')

rep('lib/widgets/dev_link.dart', r'final dynamic icon;', r'final IconData icon;')
rep('lib/widgets/dev_link.dart', r'FaIcon\(icon as dynamic, color: Colors\.white\)', r'Icon(icon, color: Colors.white)')
rep('lib/widgets/dev_link.dart', r'FaIcon\(icon as IconData, color: Colors\.white\)', r'Icon(icon, color: Colors.white)')
rep('lib/widgets/dev_link.dart', r'final Function onPressed;', r'final VoidCallback onPressed;')

rep('lib/screens/developer.dart', r'FaIcon\(icon as IconData, color: Colors\.white\)', r'Icon(icon, color: Colors.white)')

rep('lib/widgets/new_transaction.dart', r'Transaction\(id: null,', r'Transaction(id: \"\",')
rep('lib/widgets/new_transaction.dart', r'DateTime _pickedDate;', r'DateTime? _pickedDate;')
rep('lib/widgets/new_transaction.dart', r'File _imageFile;', r'File? _imageFile;')
rep('lib/widgets/new_transaction.dart', r'Directory _appLibraryDirectory;', r'late Directory _appLibraryDirectory;')
rep('lib/widgets/new_transaction.dart', r'TextEditingController _controller;', r'late TextEditingController _controller;')
rep('lib/widgets/new_transaction.dart', r'imagePath: _imageFile.path', r'imagePath: _imageFile!.path')
rep('lib/widgets/new_transaction.dart', r'_imageFile = null;', r'// _imageFile = null;')
rep('lib/widgets/new_transaction.dart', r'FlatButton\(', r'TextButton(')
rep('lib/widgets/transaction_item.dart', r'FlatButton\(', r'TextButton(')

rep('lib/widgets/select_color_card.dart', r'final Function onTap;', r'final GestureTapCallback onTap;')
rep('lib/widgets/settings_card.dart', r'final Function onTap;', r'final GestureTapCallback onTap;')

rep('lib/widgets/transaction_list.dart', r'final List<Transaction> transactions;', r'final List<Transaction>? transactions;')
rep('lib/widgets/transaction_list.dart', r'final Function deleteTransaction;', r'final Function? deleteTransaction;')

rep('pubspec.yaml', r'fl_chart: \^1\.2\.0', r'fl_chart: ^0.40.0')
rep('pubspec.yaml', r'fl_chart: \^0\.50\.0', r'fl_chart: ^0.40.0')
