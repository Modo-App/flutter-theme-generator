import 'package:theme_generator/src/utils/theme.dart';
import 'package:theme_generator/src/utils/theme_data.dart';

class Extensions {
  const Extensions._({
    this.buildContextEnabled = false,
    this.buildContextFieldName = "theme",
    this.themeResponsiveEnabled = false,
  });

  final bool buildContextEnabled;
  final String buildContextFieldName;
  final bool themeResponsiveEnabled;

  void generateBuildContextExtension(
    StringBuffer buffer,
    List<ThemeClass> themes,
    ThemeDataClass themeDataClass,
    String themeClassName,
  ) {
    if (themes.isEmpty || !buildContextEnabled) return;

    ThemeClass fallbackTheme = themes.first;

    buffer.writeln("extension BuildContextExtensions on BuildContext {");
    buffer.writeln(
        "  ${themeDataClass.className} get $buildContextFieldName => Theme.of(this).extension<${themeDataClass.className}>() ?? ${fallbackTheme.className}.get;");
    buffer.writeln();
    buffer.writeln("  void changeTheme(${themeClassName}Mode mode) => $themeClassName.changeTheme(mode);");
    buffer.writeln("}");
    buffer.writeln();
  }

  String generateColorExtension() {
    return """
extension _ColorLerpExtension on Color {
  Color lerp(Color to, double t) {
    return Color.lerp(this, to, t)!;
  }
}""";
  }

  void generateImports(StringBuffer buffer) {
    if (!themeResponsiveEnabled) return;
    buffer.writeln("import 'package:provider/provider.dart';");
  }

  void generateTypeDefs(StringBuffer buffer) {
    if (!themeResponsiveEnabled) return;
    buffer.writeln("typedef ThemeBuilder = Widget Function(BuildContext context, ThemeData currentTheme);");
    buffer.writeln();
  }

  void generateThemeResponsiveWidget(StringBuffer buffer, String themeClassName) {
    if (!themeResponsiveEnabled) return;
    buffer.writeln("""
class ThemeResponsive extends StatelessWidget {
  final ThemeBuilder builder;

  const ThemeResponsive({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: $themeClassName.instance,
      child: Consumer<$themeClassName>(
        builder: (BuildContext context, $themeClassName value, Widget? child) {
          return builder(context, value.currentThemeData);
        },
      ),
    );
  }
}
""");
  }

  static Extensions parse(Map<String, dynamic> extensions, List<ThemeClass> themes) {
    var data = extensions.isEmpty ? {"buildContext": {}, "themeResponsiveWidget": {}} : extensions;
    bool buildContextEnabled = data["buildContext"]["enabled"] ?? false;
    String buildContextFieldName = data["buildContext"]["field_name"] ?? "theme";
    bool themeResponsiveEnabled = data["themeResponsiveWidget"]["enabled"] ?? false;
    return Extensions._(
      buildContextEnabled: buildContextEnabled,
      buildContextFieldName: buildContextFieldName,
      themeResponsiveEnabled: themeResponsiveEnabled,
    );
  }
}
