This package generates a flutter theme based on a given `.theme` file.

## Getting started

To start using this package add following line to your `pubspec.yaml`.

```yaml
dev_dependencies:
  build_runner: ^2.4.6
  theme_generator:
    git:
      url: https://github.com/xNoci/flutter-theme-generator
```

In addition, you have to create a file called `build.yaml` into the root location of your porject.
This file should contain following:

```yaml
targets:
  modo:modo:
    builders:
      theme_generator|themeBuilder:
        enabled: True
```

## Usage

To generate theme you have to create a `[name].theme` file somewhere in your `/lib` folder.
This file contains JSON text which will be converted to a dart file.

It should something like this:

```yaml
{
  "theme_name": "ModoTheme",
  "theme_data": {
    "name": "ModoThemeData",
    "color_fields": [
      "background",
      "primary",
      "error"
    ]
  },
  "themes": {
    "DarkTheme": {
      "name": "dark",
      "is_dark": true,
      "colors": {
        "background": "black",
        "primary": "blue",
        "error": "red"
      }
    },
    "LightTheme": {
      "name": "light",
      "colors": {
        "background": "white",
        "primary": "0xFF00FF00",
        "error": "#FFFF0000"
      }
    }
  }
}
```

To generate your theme dart file once use `dart run build_runner build --delete-conflicting-outputs` or
use `dart run build_runner watch`to automatically regenerate the dart file if you save changes to the `.theme` file.

## The .theme file

| Value      | Description                                                                               | Type   |
|------------|-------------------------------------------------------------------------------------------|--------|
| theme_name | Set the class name for the `theme class` which<br>will give access to your themes.        | String |
| theme_data | A map containing information for the flutter `ThemeExtension`<br>which will be generated. | Map    |
| themes     | A map of themes                                                                           | Map    |

### theme_data

| Value        | Description                                                                                                                | Type        | 
|--------------|----------------------------------------------------------------------------------------------------------------------------|-------------| 
| name         | The class name for the flutter `ThemeExtension`                                                                            | String      |
| color_fields | A list of flutter `Color` fields which can be accessed in your theme.<br>Each string in this list represents a field name. | String list |

### themes

To create a new theme, you have to add a new object to the `themes` map. The key of this object will be the name of the
corresponding class that will be generated.

The object should have following key-value pairs:

| Value               | Description                                                                                                                                 | Type    | 
|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------|---------| 
| name                | The name of the getter which will give you access to the extension through the `theme class`                                                | String  |
| is_dark \<Optional> | If this is set to true, the generator will use a `ThemeData.dark()` as a template, otherwise it will use `ThemeData.light()` as a template. | boolean |
| colors              | This map will contain the `Color` field name with the associated color value.                                                               | Map     |

### colors

Example `colors` map for the `theme` object.

```yaml
"colors": {
  "background": "black",
  "primary": "0xFFFFFFFF",
  "error": "#FFFF0000"
}
```

If the string starts with a `#` or with `0x` the following hex value will be used as a color. If it does not start with
one of those symbols, the generator will take the value and add `Colors.` as a prefix to it. This will allow you to
access fields from the flutter `Colors` class.

## Generated dart file from ``Usage``

<details>
  <summary>Click me</summary>

```dart
import 'package:flutter/material.dart';

abstract class ModoTheme {
  static final dark = ThemeData.dark().copyWith(extensions: [DarkTheme.get]);
  static final light = ThemeData.light().copyWith(extensions: [LightTheme.get]);
}

class DarkTheme extends ModoThemeData {
  DarkTheme._()
      : super(
    background: Colors.black,
    primary: Colors.blue,
    error: Colors.red,
  );

  static final get = DarkTheme._();
}

class LightTheme extends ModoThemeData {
  LightTheme._()
      : super(
    background: Colors.white,
    primary: const Color(0xFF00FF00),
    error: const Color(0xFFFF0000),
  );

  static final get = LightTheme._();
}

class ModoThemeData extends ThemeExtension<ModoThemeData> {
  const ModoThemeData({
    required this.background,
    required this.primary,
    required this.error,
  });

  final Color background;
  final Color primary;
  final Color error;

  @override
  ThemeExtension<ModoThemeData> copyWith({
    Color? background,
    Color? primary,
    Color? error,
  }) =>
      ModoThemeData(
        background: background ?? this.background,
        primary: primary ?? this.primary,
        error: error ?? this.error,
      );

  @override
  ThemeExtension<ModoThemeData> lerp(covariant ThemeExtension<ModoThemeData>? other, double t) {
    if (other is! ModoThemeData) {
      return this;
    }
    return ModoThemeData(
      background: background.lerp(other.background, t),
      primary: primary.lerp(other.primary, t),
      error: error.lerp(other.error, t),
    );
  }

}

extension _ColorLerpExtension on Color {
  Color lerp(Color to, double t) {
    return Color.lerp(this, to, t)!;
  }
}
```
</details>