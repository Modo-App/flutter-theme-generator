import 'package:theme_generator/src/utils/theme.dart';
import 'package:theme_generator/src/utils/theme_data.dart';

class Extensions {
  const Extensions._({this.buildContextEnabled = false, this.buildContextFieldName = "theme"});

  final bool buildContextEnabled;
  final String buildContextFieldName;

  void generateBuildContextExtension(StringBuffer buffer, List<ThemeClass> themes, ThemeDataClass themeDataClass) {
    if (themes.isEmpty || !buildContextEnabled) return;

    ThemeClass fallbackTheme = themes.first;

    buffer.writeln("extension BuildContextExtensions on BuildContext {");
    buffer.writeln(
        "  ${themeDataClass.className} get $buildContextFieldName => Theme.of(this).extension<${themeDataClass.className}>() ?? ${fallbackTheme.className}.get;");
    buffer.writeln("}");
    buffer.writeln();
  }

  String generateColorExtension() {
    return """
extension _ColorLerpExtension on Color {
  Color lerp(Color to, double t) {
    return Color.lerp(this, to, t)!;
  }
}
""";
  }

  static Extensions parse(Map<String, dynamic> extensions, List<ThemeClass> themes) {
    var data = extensions.isEmpty ? {"buildContext": {}} : extensions;
    bool buildContextEnabled = data["buildContext"]["enabled"] ?? false;
    String buildContextFieldName = data["buildContext"]["field_name"] ?? "theme";
    return Extensions._(
      buildContextEnabled: buildContextEnabled,
      buildContextFieldName: buildContextFieldName,
    );
  }
}
