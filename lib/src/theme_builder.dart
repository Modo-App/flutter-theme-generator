import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:theme_generator/src/utils/extensions.dart';
import 'package:theme_generator/src/utils/theme.dart';
import 'package:theme_generator/src/utils/theme_class_generator.dart';
import 'package:theme_generator/src/utils/theme_data.dart';

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

    await buildStep.writeAsString(output, _generateFile(themeClassName, themeData, themes, extensions));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".theme": [".theme.dart"]
      };

  String _generateFile(
      String themeClassName, ThemeDataClass themeData, List<ThemeClass> themes, Extensions extensions) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln();
    buffer.writeln(ThemeClassGenerator(themeClassName, themes).generateClass());
    for (var theme in themes) {
      buffer.writeln(theme.generateThemeClass(themeData.className));
    }
    buffer.writeln(themeData.generateClass());
    extensions.generateBuildContextExtension(buffer, themes, themeData);
    buffer.writeln(extensions.generateColorExtension());
    return buffer.toString();
  }
}
