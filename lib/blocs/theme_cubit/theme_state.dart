part of 'theme_cubit.dart';

enum ThemeColor {
  red,
  purple,
  blue,
  green,
  indigo,
  teal,
}

ThemeData _createTheme(Color seedColor, {bool isDark = false}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    textTheme: isDark
        ? GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

final purpleTheme = _createTheme(const Color(0xFF8B5CF6));
final greenTheme = _createTheme(const Color(0xFF10B981));
final redTheme = _createTheme(const Color(0xFFEF4444));
final blueTheme = _createTheme(const Color(0xFF3B82F6));
final indigoTheme = _createTheme(const Color(0xFF6366F1));
final tealTheme = _createTheme(const Color(0xFF004D40));
final darkTheme = _createTheme(const Color(0xFF6366F1), isDark: true);

class ThemeState extends Equatable {
  final ThemeColor color;
  final ThemeData theme;

  ThemeState({
    required this.color,
    required this.theme,
  });

  factory ThemeState.initial() {
    return ThemeState(color: ThemeColor.teal, theme: tealTheme);
  }

  @override
  List<Object> get props => [color, theme];

  ThemeState copyWith({
    ThemeColor? color,
    ThemeData? theme,
  }) {
    return ThemeState(
      color: color ?? this.color,
      theme: theme ?? this.theme,
    );
  }
}


