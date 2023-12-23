import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:theme_generator/src/utils/extensions.dart';
import 'package:theme_generator/src/utils/theme.dart';
import 'package:theme_generator/src/utils/theme_class_generator.dart';
import 'package:theme_generator/src/utils/theme_data.dart';
import 'package:theme_generator/src/utils/theme_mode.dart';
import 'package:theme_generator/src/utils/typedefs.dart';

class ThemeBuilder implements Builder {
  const ThemeBuilder(this.options);

  final BuilderOptions options;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    var input = buildStep.inputId;
    var output = input.changeExtension(".theme.dart");
    var data = jsonDecode(await buildStep.readAsString(input));

    String themeClassName = data["theme_name"] ?? "AppTheme";
    ThemeDataClass themeData = ThemeDataClass.parse(data["theme_data"]);
    List<ThemeClass> themes = ThemeClass.parseThemes(data["themes"]);
    Extensions extensions = Extensions.parse(data["extensions"] ?? {}, themes);
    ThemeModeClass themeModes = ThemeModeClass(themeClassName: themeClassName, themes: themes);
    TypeDefGenerator typeDefGenerator = TypeDefGenerator(
      themeResponsiveWidgetEnabled: extensions.themeResponsiveWidgetEnabled,
    );

    //TODO Add safe and load function

    await buildStep.writeAsString(
        output, _generateFile(themeClassName, themeData, themeModes, themes, extensions, typeDefGenerator));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".theme": [".theme.dart"]
      };

  String _generateFile(
    String themeClassName,
    ThemeDataClass themeData,
    ThemeModeClass themeModeClass,
    List<ThemeClass> themes,
    Extensions extensions,
    TypeDefGenerator typeDefGenerator,
  ) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("""
import 'dart:ui';

import 'package:flutter/material.dart';""");
    extensions.generateImports(buffer);
    buffer.writeln();
    typeDefGenerator.generateThemeModes(buffer);
    buffer.writeln(ThemeClassGenerator(themeClassName, themes).generateClass());
    buffer.writeln(themeModeClass.generateThemeModes());
    for (var theme in themes) {
      buffer.writeln(theme.generateThemeClass(themeData.className));
    }
    buffer.writeln(themeData.generateClass());
    extensions
      ..generateThemeResponsiveWidget(buffer, themeClassName)
      ..generateBuildContextExtension(buffer, themes, themeData, themeClassName)
      ..generateColorExtension(buffer)
      ..generateDoubleAsRadiusExtension(buffer);
    return buffer.toString();
  }
}
