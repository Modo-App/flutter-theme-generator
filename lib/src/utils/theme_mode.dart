import 'package:theme_generator/src/utils/theme.dart';

class ThemeModeClass {
  const ThemeModeClass({required this.themeClassName, required this.themes});

  final String themeClassName;
  final List<ThemeClass> themes;

  String generateThemeModes() {
    StringBuffer buffer = StringBuffer();

    buffer.writeln("enum ${themeClassName}Mode {");
    buffer.writeln("  system,");
    for (var theme in themes) {
      buffer.writeln("  ${theme.name},");
    }
    buffer.writeln("}");
    return buffer.toString();
  }
}
