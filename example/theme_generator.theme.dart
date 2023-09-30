import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTheme extends ChangeNotifier {
  static final dark = ThemeData.dark().copyWith(extensions: [DarkTheme.get]);
  static final light = ThemeData.light().copyWith(extensions: [LightTheme.get]);

  static List<ThemeData> get themes => [
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

extension _ColorLerpExtension on Color {
  Color lerp(Color to, double t) {
    return Color.lerp(this, to, t)!;
  }
}
