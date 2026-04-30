import os
import re

def rep(p, s, r):
    with open(p, 'r', encoding='utf-8') as f:
        c = f.read()
    c = re.sub(s, r, c)
    with open(p, 'w', encoding='utf-8') as f:
        f.write(c)

rep('lib/blocs/google_ads/googleads_state.dart', r'Future<InitializationStatus> adsState,', r'Future<InitializationStatus>? adsState,')
rep('lib/blocs/google_ads/googleads_state.dart', r'AdsStatus status,', r'AdsStatus? status,')
rep('lib/blocs/google_ads/googleads_state.dart', r'BannerAd bannerAd,', r'BannerAd? bannerAd,')

rep('lib/blocs/search_cubit/search_state.dart', r'List<Transaction> transactions,', r'List<Transaction>? transactions,')
rep('lib/blocs/search_cubit/search_state.dart', r'SearchStatus status,', r'SearchStatus? status,')
rep('lib/blocs/search_cubit/search_state.dart', r'String error,', r'String? error,')

rep('lib/blocs/theme_cubit/theme_state.dart', r'Color color,', r'Color? color,')
rep('lib/blocs/theme_cubit/theme_state.dart', r'ThemeData theme,', r'ThemeData? theme,')

rep('lib/blocs/transactions/transactions_state.dart', r'List<Transaction> transactionsList,', r'List<Transaction>? transactionsList,')
rep('lib/blocs/transactions/transactions_state.dart', r'TransactionsStatus status,', r'TransactionsStatus? status,')
rep('lib/blocs/transactions/transactions_state.dart', r'String error,', r'String? error,')

rep('lib/models/transaction.dart', r'String id,', r'String? id,')
rep('lib/models/transaction.dart', r'String title,', r'String? title,')
rep('lib/models/transaction.dart', r'String amount,', r'String? amount,')
rep('lib/models/transaction.dart', r'DateTime date,', r'DateTime? date,')
rep('lib/models/transaction.dart', r'DateTime createdOn,', r'DateTime? createdOn,')
rep('lib/models/transaction.dart', r'String imagePath,', r'String? imagePath,')

rep('lib/repositories/transactions_repository.dart', r'String _dbPath;', r'late String _dbPath;')
rep('lib/repositories/transactions_repository.dart', r'sqf.Database _db;', r'late sqf.Database _db;')
rep('lib/repositories/transactions_repository.dart', r'final List<Map> tList', r'final List<Map<String, dynamic>> tList')
rep('lib/repositories/transactions_repository.dart', r'final List<Transaction> transactions =[\s\n]*tList\.map\(\(tMap\) => Transaction\.fromMap\(tMap\)\)\.toList\(\);', r'final List<Transaction> transactions = tList.map((tMap) => Transaction.fromMap(Map<String, dynamic>.from(tMap))).toList();')

rep('lib/screens/about.dart', r'PackageInfo packageInfo;', r'late PackageInfo packageInfo;')

rep('lib/blocs/search_cubit/search_cubit.dart', r'error: e', r'error: e.toString()')
rep('lib/blocs/transactions/transactions_bloc.dart', r'error: e', r'error: e.toString()')

rep('lib/widgets/dev_link.dart', r'final IconData icon;', r'final dynamic icon;')

rep('lib/screens/developer.dart', r'FaIcon\(icon, color: Colors.white\)', r'FaIcon(icon as IconData, color: Colors.white)')
rep('lib/widgets/dev_link.dart', r'FaIcon\(icon, color: Colors.white\)', r'FaIcon(icon as IconData, color: Colors.white)')
rep('lib/widgets/dev_link.dart', r'FaIcon\(icon', r'FaIcon(icon as dynamic')

rep('lib/screens/home.dart', r'max > 0', r'(max ?? 0) > 0')
rep('lib/screens/home.dart', r'max < 0', r'(max ?? 0) < 0')

rep('lib/screens/developer.dart', r'canLaunch\(url\)', r'canLaunchUrl(Uri.parse(url))')
rep('lib/screens/developer.dart', r'launch\([\s\S]*?\)', r'launchUrl(Uri.parse(url))')
rep('lib/screens/settings.dart', r'canLaunch\(url\)', r'canLaunchUrl(Uri.parse(url))')
rep('lib/screens/settings.dart', r'launch\(url\)', r'launchUrl(Uri.parse(url))')
