import 'package:theme_generator/src/utils/theme.dart';

class ThemeClassGenerator {
  const ThemeClassGenerator(this.className, this.themes);

  final String className;
  final List<ThemeClass> themes;

  String generateClass() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("abstract class $className {");
    for (var theme in themes) {
      buffer.writeln(theme.generateThemeGetter());
    }
    buffer.writeln("}");
    return buffer.toString();
  }
}
