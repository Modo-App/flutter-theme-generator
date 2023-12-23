import 'package:theme_generator/src/utils/theme.dart';
import 'package:theme_generator/src/utils/theme_data.dart';

class Extensions {
  const Extensions._({
    this.buildContextEnabled = false,
    this.buildContextFieldName = "theme",
    this.themeResponsiveWidgetEnabled = true,
    this.colorMaterialPropertyEnabled = true,
    this.doubleAsRadiusEnabled = true,
  });

  final bool buildContextEnabled;
  final String buildContextFieldName;
  final bool themeResponsiveWidgetEnabled;
  final bool colorMaterialPropertyEnabled;
  final bool doubleAsRadiusEnabled;

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
        "  ${themeDataClass.className} get $buildContextFieldName => Theme.of(this).extension<${themeDataClass.className}>() ?? ${fallbackTheme.className}.get();");
    buffer.writeln();
    buffer.writeln("  void changeTheme(${themeClassName}Mode mode) => $themeClassName.changeTheme(mode);");
    buffer.writeln("}");
    buffer.writeln();
  }

  void generateColorExtension(StringBuffer buffer) {
    buffer.writeln("extension ColorsExtension on Color {");
    buffer.writeln("  Color lerp(Color to, double t) =>  Color.lerp(this, to, t)!;");
    if (colorMaterialPropertyEnabled) {
      buffer.writeln();
      buffer.writeln("  MaterialStateProperty<Color> get materialProperty => MaterialStateProperty.all<Color>(this);");
    }
    buffer.writeln("}");
    buffer.writeln();
  }

  void generateDoubleAsRadiusExtension(StringBuffer buffer) {
    if (!doubleAsRadiusEnabled) return;
    buffer.writeln("extension DoubleAsRadiusExtension on double {");
    buffer.writeln("  Radius asRadius() => Radius.circular(this);");
    buffer.writeln();
    buffer.writeln("  BorderRadius asBorderRadius() => BorderRadius.circular(this);");
    buffer.writeln("}");
  }

  void generateImports(StringBuffer buffer) {
    if (!themeResponsiveWidgetEnabled) return;
    buffer.writeln("import 'package:provider/provider.dart';");
  }

  void generateThemeResponsiveWidget(StringBuffer buffer, String themeClassName) {
    if (!themeResponsiveWidgetEnabled) return;
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
          return builder(context, value.currentThemeData());
        },
      ),
    );
  }
}
""");
  }

  static Extensions parse(Map<String, dynamic> extensions, List<ThemeClass> themes) {
    var data = extensions.isEmpty ? {"buildContext": {}, "themeResponsiveWidget": {}} : extensions;
    var buildContext = data.isEmpty ? {} : data["buildContext"] ?? {};
    var themeResponsiveWidget = data.isEmpty ? {} : data["themeResponsiveWidget"] ?? {};
    var colorMaterialProperty = data.isEmpty ? {} : data["colorMaterialProperty"] ?? {};
    var doubleAsRadius = data.isEmpty ? {} : data["doubleAsRadius"] ?? {};

    bool buildContextEnabled = buildContext["enabled"] ?? false;
    String buildContextFieldName = buildContext["field_name"] ?? "theme";
    bool themeResponsiveWidgetEnabled = themeResponsiveWidget["enabled"] ?? true;
    bool colorMaterialPropertyEnabled = colorMaterialProperty["enabled"] ?? true;
    bool doubleAsRadiusEnabled = doubleAsRadius["enabled"] ?? true;
    return Extensions._(
      buildContextEnabled: buildContextEnabled,
      buildContextFieldName: buildContextFieldName,
      themeResponsiveWidgetEnabled: themeResponsiveWidgetEnabled,
      colorMaterialPropertyEnabled: colorMaterialPropertyEnabled,
      doubleAsRadiusEnabled: doubleAsRadiusEnabled,
    );
  }
}
