class ThemeDataClass {
  const ThemeDataClass({required this.className, required this.colors});

  final String className;
  final List<String> colors;

  String generateClass() {
    StringBuffer buffer = StringBuffer();

    buffer.writeln("class $className extends ThemeExtension<$className> {");
    buffer.writeln("  const $className({");
    for(var color in colors) {
      buffer.writeln("    required this.$color,");
    }
    buffer.writeln("  });");
    buffer.writeln();
    for(var color in colors) {
      buffer.writeln("  final Color $color;");
    }
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  ThemeExtension<$className> copyWith({");
    for(var color in colors) {
      buffer.writeln("    Color? $color,");
    }
    buffer.writeln("  }) =>");
    buffer.writeln("      $className(");
    for(var color in colors) {
      buffer.writeln("        $color: $color ?? this.$color,");
    }
    buffer.writeln("      );");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  ThemeExtension<$className> lerp(covariant ThemeExtension<$className>? other, double t) {");
    buffer.writeln("    if (other is! $className) {");
    buffer.writeln("      return this;");
    buffer.writeln("    }");
    buffer.writeln("    return $className(");
    for(var color in colors) {
      buffer.writeln("      $color: $color.lerp(other.$color, t),");
    }
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("}");

    return buffer.toString();
  }

  static ThemeDataClass parse(Map<String, dynamic> data) {
    String name = data["name"];
    List<dynamic> colors = data["colors"];
    List<String> stringColors = colors.map((e) => e.toString()).toList();
    return ThemeDataClass(className: name, colors: stringColors);
  }
}
