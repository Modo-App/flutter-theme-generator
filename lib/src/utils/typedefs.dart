class TypeDefGenerator {
  const TypeDefGenerator({required this.themeResponsiveWidgetEnabled});

  final bool themeResponsiveWidgetEnabled;

  String generateThemeModes(StringBuffer buffer) {
    buffer.writeln("typedef ThemeDataFunc = ThemeData Function();");
    if (themeResponsiveWidgetEnabled) {
      buffer.writeln("typedef ThemeBuilder = Widget Function(BuildContext context, ThemeData currentTheme);");
    }
    buffer.writeln();

    return buffer.toString();
  }
}
