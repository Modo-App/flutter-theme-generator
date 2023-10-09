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

It should look something like this:

```yaml
{
  "theme_name": "AppTheme",
  "theme_data": {
    "name": "AppThemeData",
    "color_fields": [
      "background",
      "primary",
      "error"
    ],
    "double_fields": [
      "borderRadius"
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
      },
      "doubles": {
        "borderRadius": 8
      }
    },
    "LightTheme": {
      "name": "light",
      "colors": {
        "background": "white",
        "primary": "0xFF00FF00",
        "error": "#FFFF0000"
      },
      "doubles": {
        "borderRadius": 10
      }
    }
  },
  "extensions": {
    "buildContext": {
      "enabled": true,
      "field_name": "appTheme"
    },
    "themeResponsiveWidget": {
      "enabled": true
    },
    "colorMaterialProperty": {
      "enabled": true
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

### Theme data

| Value         | Description                                                                                                                | Type        | 
|---------------|----------------------------------------------------------------------------------------------------------------------------|-------------| 
| name          | The class name for the flutter `ThemeExtension`                                                                            | String      |
| color_fields  | A list of flutter `Color` fields which can be accessed in your theme.<br>Each string in this list represents a field name. | String list |
| double_fields | A list of `double` fields which can be accessed in your theme.<br>Each string in this list represents a field name.        | String list |

### Themes

To create a new theme, you have to add a new object to the `themes` map. The key of this object will be the name of the
corresponding class that will be generated.

The object should have following key-value pairs:

| Value                  | Description                                                                                                                                                                                                                                                                                                                                                     | Type    | 
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------| 
| name                   | The name of the getter which will give you access to the extension through the `theme class`                                                                                                                                                                                                                                                                    | String  |
| is_dark<br>\<Optional> | If this is set to true, the generator will use `ThemeData.dark()` as a template, otherwise it will use `ThemeData.light()` as a template.<br>Furthermore, if this value is set to true, the `isDark` getter for this theme will return true, otherwise it will return false. This can be used to check if the current active theme is a dark mode theme or not. | boolean |
| colors                 | This map will contain the `Color` field name with the associated color value.                                                                                                                                                                                                                                                                                   | Map     |
| doubles                | This map will contain the `double` field name with the associated double value.                                                                                                                                                                                                                                                                                 | Map     |

#### Themes - colors

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

#### Themes - doubles

Example `doubles` map for the `theme` object.

```yaml
"doubles": {
  "borderRadius": "10"
}
```

### Extensions

The generator has also the option to add extensions, which allow you to add optional functionality. To use this, just
add an object called `extensions` to your `.theme` file.

| Value                                | Description                                                                                                                                                                    | Type |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| buildContext<br>\<Optional>          | This extension gives you an easier access to your themes using `BuildContext`.                                                                                                 | Map  |
| themeResponsiveWidget<br>\<Optional> | This extension adds a widget which gives you a simple way to switch between themes. To use this extension the [provider package](https://pub.dev/packages/provider) is needed. | Map  |
| colorMaterialProperty<br>\<Optional> | This extension adds a getter to the flutter `Color` class to get the `MaterialStateProperty<Color>` value of a color.                                                          | Map  |

#### Extension - buildContext

The buildContext extension is turned off by default. This extension needs at least one theme to be generated.

| Value      | Description                                                                          | Type    |
|------------|--------------------------------------------------------------------------------------|---------|
| enabled    | When set to true, the extension will be generated. Defaults to `false`.              | boolean |
| field_name | The fieldName to access your themes through the `BuildContext`. Defaults to `theme`. | String  |

<details>
    <summary>Usage</summary>
<h6>Getting current theme</h6>
You can get the current theme through `BuildContext` by using:

`context.<field_name>`; For the example above it would look like: `context.appTheme`.
<h6>Switching themes</h6>
You can switch themes, if `themeResponsiveWidget` is enabled, by accessing the `changeTheme` method through
the `BuildContext`:

`context.changeTheme(AppThemeMode.system);`
</details>

#### Extension - themeResponsiveWidget

The themeResponsiveWidget extension is turned on by default. To work, this extension needs
the [provider package](https://pub.dev/packages/provider).

| Value   | Description                                                              | Type    |
|---------|--------------------------------------------------------------------------|---------|
| enabled | When set to false, the widget will not be generated. Defaults to `true`. | boolean |

<details>
    <summary>Usage</summary>
<h4>Apply the widget</h4>
To use this widget you have to wrap your <code>MaterialApp</code> with the <code>ThemeResponsive</code> widget and set the <code>theme</code> to <code>currentTheme</code>:

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeResponsive(
      builder: (BuildContext context, ThemeData currentTheme) {
        return MaterialApp(
          theme: currentTheme,
          home: Container(),
        );
      },
    );
  }
}
```

<h4>Switching themes</h4>

You can than switch themes by calling your `theme class` and using the `changeTheme` method:

`AppTheme.changeTheme(AppThemeMode.dark);`

or if you are enabling the `buildContext` extension you can access the `changeTheme` method through the `BuildContext`:

`context.changeTheme(AppThemeMode.system);`
</details>

#### Extension - colorMaterialProperty

The colorMaterialProperty extension is turned on by default.

| Value   | Description                                                            | Type    |
|---------|------------------------------------------------------------------------|---------|
| enabled | When set to true, the extension will be generated. Defaults to `true`. | boolean |

<details>
    <summary>Usage</summary>
    <h6>Getting MaterialPropertyState of a color</h6>
    <code>Colors.red.materialProperty;</code>
</details>

## ThemeModes

The generator will also create an enum which will be named `<theme_name>Mode`. This enum class will have following
values:

- system
- For each of your theme an enum called after the `name` field of the theme.

For the above example it would look like this:

```dart
enum AppThemeMode {
  system,
  dark,
  light,
}
```

The enum is needed to change between the themes. If the `system` theme is selected. It will search the first theme that
has the correct brightness. This means if the device is currently in dark mode, it will take the first theme which has
the property `is_dark` set to `true`. If the device is in light mode, it will select the first theme that has
either `is_dark` set to `false` or do not have set the property at all.
However, if the system cannot find a dark/light mode, it will take the first theme it can find, no matter if it has the
correct brightness.

## Generated dart file from ``Usage``

<details>
  <summary>Click me</summary>

```dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTheme extends ChangeNotifier {
  static final dark = ThemeData.dark().copyWith(extensions: [DarkTheme.get]);
  static final light = ThemeData.light().copyWith(extensions: [LightTheme.get]);

  static List<ThemeData> get themes =>
      [
        dark,
        light,
      ];

  static void changeTheme(AppThemeMode mode) {
    AppTheme instance = AppTheme.instance;
    instance._currentThemeData = _dataFromMode(mode);
    instance._isSystemTheme = mode == AppThemeMode.system;
    instance.notifyListeners();
  }

  static ThemeData _dataFromMode(AppThemeMode mode) {
    if (mode == AppThemeMode.dark) return dark;
    if (mode == AppThemeMode.light) return light;

    var brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return themes.firstWhere((theme) => theme.brightness == brightness, orElse: () => themes.first);
  }

  AppTheme._() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (!_isSystemTheme) return;
      changeTheme(AppThemeMode.system);
    };
  }

  bool _isSystemTheme = false;
  ThemeData _currentThemeData = dark;

  ThemeData get currentThemeData => _currentThemeData;

  static AppTheme? _instance;

  static AppTheme get instance {
    _instance ??= AppTheme._();
    return _instance!;
  }

}

enum AppThemeMode {
  system,
  dark,
  light,
}

class DarkTheme extends AppThemeData {
  DarkTheme._()
      : super(
    background: Colors.black,
    primary: Colors.blue,
    error: Colors.red,
    borderRadius: 8,
  );

  @override
  bool get isDark => true;

  static final get = DarkTheme._();
}

class LightTheme extends AppThemeData {
  LightTheme._()
      : super(
    background: Colors.white,
    primary: const Color(0xFF00FF00),
    error: const Color(0xFFFF0000),
    borderRadius: 10,
  );

  static final get = LightTheme._();
}

class AppThemeData extends ThemeExtension<AppThemeData> {
  const AppThemeData({
    required this.background,
    required this.primary,
    required this.error,
    required this.borderRadius,
  });

  final Color background;
  final Color primary;
  final Color error;
  final double borderRadius;

  bool get isDark => false;

  @override
  ThemeExtension<AppThemeData> copyWith({
    Color? background,
    Color? primary,
    Color? error,
    double? borderRadius,
  }) =>
      AppThemeData(
        background: background ?? this.background,
        primary: primary ?? this.primary,
        error: error ?? this.error,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  @override
  ThemeExtension<AppThemeData> lerp(covariant ThemeExtension<AppThemeData>? other, double t) {
    if (other is! AppThemeData) {
      return this;
    }
    return AppThemeData(
      background: background.lerp(other.background, t),
      primary: primary.lerp(other.primary, t),
      error: error.lerp(other.error, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
    );
  }
}

typedef ThemeBuilder = Widget Function(BuildContext context, ThemeData currentTheme);

class ThemeResponsive extends StatelessWidget {
  final ThemeBuilder builder;

  const ThemeResponsive({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AppTheme.instance,
      child: Consumer<AppTheme>(
        builder: (BuildContext context, AppTheme value, Widget? child) {
          return builder(context, value.currentThemeData);
        },
      ),
    );
  }
}

extension BuildContextExtensions on BuildContext {
  AppThemeData get appTheme => Theme.of(this).extension<AppThemeData>() ?? DarkTheme.get;

  void changeTheme(AppThemeMode mode) => AppTheme.changeTheme(mode);
}

extension ColorsExtension on Color {
  Color lerp(Color to, double t) => Color.lerp(this, to, t)!;

  MaterialStateProperty<Color> get materialProperty => MaterialStateProperty.all<Color>(this);
}

```

</details>