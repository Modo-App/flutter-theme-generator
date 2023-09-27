import 'package:flutter/material.dart';

abstract class AppTheme {
  static final dark = ThemeData.dark().copyWith(extensions: [DarkTheme.get]);
  static final light = ThemeData.light().copyWith(extensions: [LightTheme.get]);
  static final halloween = ThemeData.dark().copyWith(extensions: [Halloween.get]);
  static final xmas = ThemeData.light().copyWith(extensions: [XMasTheme.get]);
}

class DarkTheme extends AppThemeData {
  DarkTheme._()
    : super(
          background: Colors.black,
          primary: Colors.blue,
          error: Colors.red,
        );

  static final get = DarkTheme._();
}

class LightTheme extends AppThemeData {
  LightTheme._()
    : super(
          background: Colors.white,
          primary: Colors.green,
          error: Colors.red,
        );

  static final get = LightTheme._();
}

class Halloween extends AppThemeData {
  Halloween._()
    : super(
          background: Colors.black,
          primary: Colors.orange,
          error: Colors.red,
        );

  static final get = Halloween._();
}

class XMasTheme extends AppThemeData {
  XMasTheme._()
    : super(
          background: Colors.white,
          primary: const Color(0xFFFF0000),
          error: const Color(0xFF00FF00),
        );

  static final get = XMasTheme._();
}

class AppThemeData extends ThemeExtension<AppThemeData> {
  const AppThemeData({
    required this.background,
    required this.primary,
    required this.error,
  });

  final Color background;
  final Color primary;
  final Color error;

  @override
  ThemeExtension<AppThemeData> copyWith({
    Color? background,
    Color? primary,
    Color? error,
  }) =>
      AppThemeData(
        background: background ?? this.background,
        primary: primary ?? this.primary,
        error: error ?? this.error,
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
    );
  }

}

extension _ColorLerpExtension on Color {
  Color lerp(Color to, double t) {
    return Color.lerp(this, to, t)!;
  }
}

