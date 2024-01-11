import 'package:theme_generator/src/utils/theme.dart';

class ThemeClassGenerator {
  const ThemeClassGenerator(this.className, this.themes);

  final String className;
  final List<ThemeClass> themes;

  String generateClass() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("class $className with ChangeNotifier {");
    _generateThemeGetters(buffer);
    buffer.writeln();
    _generateThemesGetter(buffer);
    buffer.writeln();
    _generateChangeThemeMethod(buffer);
    buffer.writeln();
    _generateDataFromModeMethod(buffer);
    buffer.writeln();
    _generateClassPart(buffer);
    buffer.writeln("}");
    return buffer.toString();
  }

  void _generateThemeGetters(StringBuffer buffer) {
    for (var theme in themes) {
      buffer.writeln(theme.generateThemeGetter());
    }
  }

  void _generateThemesGetter(StringBuffer buffer) {
    buffer.writeln("  static List<ThemeDataFunc> get themes => [");
    for (var theme in themes) {
      buffer.writeln("        ${theme.name},");
    }
    buffer.writeln("      ];");
  }

  void _generateChangeThemeMethod(StringBuffer buffer) {
    buffer.writeln("  static void changeTheme(${className}Mode mode) {");
    buffer.writeln("    $className instance = $className.instance;");
    buffer.writeln("    instance._currentThemeData = _dataFromMode(mode);");
    buffer.writeln("    instance._isSystemTheme = mode == ${className}Mode.system;");
    buffer.writeln("    instance.notifyListeners();");
    buffer.writeln("  }");
  }

  void _generateDataFromModeMethod(StringBuffer buffer) {
    buffer.writeln("  static ThemeDataFunc _dataFromMode(${className}Mode mode) {");
    for (var theme in themes) {
      buffer.writeln("    if (mode == ${className}Mode.${theme.name}) return ${theme.name};");
    }
    buffer.writeln();
    buffer.writeln("    var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;");
    buffer.writeln(
        "    return themes.firstWhere((theme) => theme().brightness == brightness, orElse: () => themes.first);");
    buffer.writeln("  }");
  }

  void _generateClassPart(StringBuffer buffer) {
    buffer.writeln("""
  $className._() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (!_isSystemTheme) return;
      changeTheme(${className}Mode.system);
    };
  }

  bool _isSystemTheme = false;
  ThemeDataFunc _currentThemeData = dark;

  ThemeData currentThemeData() => _currentThemeData();

  static $className? _instance;

  static $className get instance {
    _instance ??= $className._();
    return _instance!;
  }
""");
  }
}
