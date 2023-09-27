class ThemeClass {
  ThemeClass({required this.className, required this.name, required this.isDark, required this.colors});

  final String className;
  final String name;
  final bool isDark;
  final Map<String, String> colors;

  String generateThemeGetter() {
    return "  static final $name = ThemeData.${isDark ? "dark" : "light"}().copyWith(extensions: [$className.get]);";
  }

  String generateThemeClass(String themeDataClassName) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("class $className extends $themeDataClassName {");
    buffer.writeln("  $className._()");
    buffer.writeln("      : super(");

    colors.forEach((key, value) {
      buffer.writeln("          $key: ${_parseColor(value)},");
    });

    buffer.writeln("        );");
    buffer.writeln();
    buffer.writeln("  static final get = $className._();");
    buffer.writeln("}");
    return buffer.toString();
  }

  String _parseColor(String color) {
    if (color.startsWith("0x")) return "const Color($color)";
    if (color.startsWith("#")) return "const Color(${color.replaceFirst("#", "0x")})";
    return "Colors.$color";
  }

  static List<ThemeClass> parseThemes(Map<String, dynamic> themes) {
    List<ThemeClass> output = [];

    themes.forEach((key, value) {
      Map<String, dynamic> colors = value["colors"] ?? {};
      Map<String, String> stringColors = colors.map((key, value) => MapEntry(key, value.toString()));

      output.add(
        ThemeClass(
          className: key,
          name: value["name"] ?? key,
          isDark: value["is_dark"] ?? false,
          colors: stringColors,
        ),
      );
    });

    return output;
  }
}
