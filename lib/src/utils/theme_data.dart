class ThemeDataClass {
  const ThemeDataClass._({required this.className, required this.colors, required this.doubles});

  final String className;
  final List<String> colors;
  final List<String> doubles;

  String generateClass() {
    StringBuffer buffer = StringBuffer();

    buffer.writeln("class $className extends ThemeExtension<$className> {");
    buffer.writeln("  const $className({");

    for (var color in colors) {
      buffer.writeln("    required this.$color,");
    }
    for (var double in doubles) {
      buffer.writeln("    required this.$double,");
    }

    buffer.writeln("  });");
    buffer.writeln();

    for (var color in colors) {
      buffer.writeln("  final Color $color;");
    }
    for (var double in doubles) {
      buffer.writeln("  final double $double;");
    }
    buffer.writeln();
    buffer.writeln("  bool get isDark => false;");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  ThemeExtension<$className> copyWith({");

    for (var color in colors) {
      buffer.writeln("    Color? $color,");
    }
    for (var double in doubles) {
      buffer.writeln("    double? $double,");
    }

    buffer.writeln("  }) =>");
    buffer.writeln("      $className(");

    for (var color in colors) {
      buffer.writeln("        $color: $color ?? this.$color,");
    }
    for (var double in doubles) {
      buffer.writeln("        $double: $double ?? this.$double,");
    }

    buffer.writeln("      );");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  ThemeExtension<$className> lerp(covariant ThemeExtension<$className>? other, double t) {");
    buffer.writeln("    if (other is! $className) {");
    buffer.writeln("      return this;");
    buffer.writeln("    }");
    buffer.writeln("    return $className(");

    for (var color in colors) {
      buffer.writeln("      $color: $color.lerp(other.$color, t),");
    }
    for (var double in doubles) {
      buffer.writeln("      $double: lerpDouble($double, other.$double, t)!,");
    }

    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  static ThemeDataClass parse(Map<String, dynamic> data) {
    String name = data["name"];
    List<dynamic> colors = data["color_fields"] ?? [];
    List<dynamic> doubles = data["double_fields"] ?? [];
    List<String> stringColors = colors.map((e) => e.toString()).toList();
    List<String> stringDoubles = doubles.map((e) => e.toString()).toList();
    return ThemeDataClass._(
      className: name,
      colors: stringColors,
      doubles: stringDoubles,
    );
  }
}
