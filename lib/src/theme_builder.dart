import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:theme_generator/src/utils/extensions.dart';
import 'package:theme_generator/src/utils/theme.dart';
import 'package:theme_generator/src/utils/theme_class_generator.dart';
import 'package:theme_generator/src/utils/theme_data.dart';
import 'package:theme_generator/src/utils/theme_mode.dart';

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

    await buildStep.writeAsString(output, _generateFile(themeClassName, themeData, themeModes, themes, extensions));
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
  ) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("""
import 'dart:ui';

import 'package:flutter/material.dart';""");
    extensions.generateImports(buffer);
    buffer.writeln();
    buffer.writeln(ThemeClassGenerator(themeClassName, themes).generateClass());
    buffer.writeln(themeModeClass.generateThemeModes());
    for (var theme in themes) {
      buffer.writeln(theme.generateThemeClass(themeData.className));
    }
    buffer.writeln(themeData.generateClass());
    extensions.generateTypeDefs(buffer);
    extensions.generateThemeResponsiveWidget(buffer, themeClassName);
    extensions.generateBuildContextExtension(buffer, themes, themeData, themeClassName);
    extensions.generateColorExtension(buffer);
    return buffer.toString();
  }
}
