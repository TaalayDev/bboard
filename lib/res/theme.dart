import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/storage.dart';

extension ContextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  AppTheme get appTheme => AppTheme.theme;
}

extension AppThemeExtensions on ThemeData {
  Color get background => AppTheme.theme.bgColor;
  Color get background1 => AppTheme.theme.bgColor1;
  Color get background2 => AppTheme.theme.bgColor2;
  Color get primary => AppTheme.theme.primaryColor;
  Color get onPrimary => AppTheme.theme.onPrimaryColor;
  Color get primaryTint => AppTheme.theme.primaryTintColor;
  Color get secondary => AppTheme.theme.secondaryColor;
  Color get accent => AppTheme.theme.accentColor;
  Color get onAccent => AppTheme.theme.onAccentColor;
  Color get focus => AppTheme.theme.focusColor;
  Color get onFocus => AppTheme.theme.onFocusColor;
  Color get surface => AppTheme.theme.surface;
  Color get greyWeak => AppTheme.theme.greyWeakColor;
  Color get grey => AppTheme.theme.greyColor;
  Color get greyMedium => AppTheme.theme.greyMediumColor;
  Color get greyStrong => AppTheme.theme.greyStrongColor;

  Color get mainTextColor => AppTheme.theme.mainTextColor;
  Color get secondTextColor => AppTheme.theme.secondTextColor;
  Color get inverseTextColor => AppTheme.theme.inverseTextColor;
}

// Themes
enum ThemeType {
  LIGHT_GREEN,
  DARK_GREEN,
}

class AppTheme {
  static const ThemeType defaultTheme = ThemeType.LIGHT_GREEN;

  late ThemeType type;
  bool isDark;

  late Color primaryColor;
  late Color onPrimaryColor;
  late Color primaryTintColor;
  late Color secondaryColor;
  late Color accentColor;
  late Color onAccentColor;
  late Color bgColor;
  late Color bgColor1;
  late Color bgColor2;
  late Color focusColor;
  late Color onFocusColor;
  late Color greyWeakColor;
  late Color greyColor;
  late Color greyMediumColor;
  late Color greyStrongColor;
  late Color surface;

  late Color mainTextColor;
  late Color secondTextColor;
  late Color inverseTextColor;

  AppTheme({this.isDark = false}) {
    mainTextColor = isDark ? Colors.white : Colors.black;
    secondTextColor = const Color(0xFF8A8A8A);
    inverseTextColor = isDark ? Colors.black : Colors.white;
  }

  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.LIGHT_GREEN:
        return AppTheme(isDark: false)
          ..type = t
          ..primaryColor = const Color.fromARGB(255, 55, 174, 113)
          ..onPrimaryColor = const Color(0xFFFFFFFF)
          ..primaryTintColor = const Color(0x3000BB29)
          ..accentColor = const Color(0xFFD0103F)
          ..onAccentColor = const Color(0xFFFFFFFF)
          ..focusColor = const Color(0x3000BB29)
          ..onFocusColor = const Color(0xFFFFFFFF)
          ..secondaryColor = const Color(0xFF000000)
          ..bgColor = const Color(0xFFFFFFFF)
          ..bgColor1 = const Color(0xFFdbe5f1)
          ..bgColor2 = const Color(0xFFf0f3f8)
          ..surface = const Color(0xFFFFFFFF)
          ..greyWeakColor = const Color(0xffeeeeee)
          ..greyColor = const Color(0xff8a8a8a)
          ..greyMediumColor = const Color(0xff747474)
          ..greyStrongColor = const Color(0xff333333);
      case ThemeType.DARK_GREEN:
        return AppTheme(isDark: true)
          ..type = t
          ..primaryColor = const Color.fromARGB(255, 55, 174, 113)
          ..onPrimaryColor = const Color(0xFFFFFFFF)
          ..primaryTintColor = const Color(0x3000BB29)
          ..accentColor = const Color(0xFFD0103F)
          ..onAccentColor = const Color(0xFFFFFFFF)
          ..focusColor = const Color(0x3000BB29)
          ..onFocusColor = const Color(0xFFFFFFFF)
          ..secondaryColor = const Color(0xFFFFFFFF)
          ..bgColor = const Color(0xFF263236)
          ..bgColor1 = const Color(0xFFdbe5f1)
          ..bgColor2 = const Color(0xFFf0f3f8)
          ..surface = const Color(0xFFFFFFFF)
          ..greyWeakColor = const Color(0xffeeeeee)
          ..greyColor = const Color(0xff8a8a8a)
          ..greyMediumColor = const Color(0xff747474)
          ..greyStrongColor = const Color(0xff333333);
    }

    // return AppTheme.fromType(defaultTheme);
  }

  ThemeData get themeData {
    final textThemeData =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    var t = ThemeData.from(
      // Use the .dark() and .light() constructors to handle the text themes
      textTheme: GoogleFonts.robotoTextTheme(textThemeData),
      // Use ColorScheme to generate the bulk of the color theme
      colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: primaryColor,
          primaryVariant: shift(primaryColor, .1),
          secondary: secondaryColor,
          secondaryVariant: shift(primaryColor, .1),
          background: bgColor2,
          surface: surface,
          onBackground: mainTextColor,
          onSurface: mainTextColor,
          onError: mainTextColor,
          onPrimary: inverseTextColor,
          onSecondary: inverseTextColor,
          error: focusColor),
    );
    // Apply additional styling that is missed by ColorScheme
    // All done, return the ThemeData
    return t.copyWith(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryColor,
          selectionHandleColor: Colors.transparent,
          selectionColor: primaryColor,
        ),
        buttonTheme: ButtonThemeData(
          height: 55,
          buttonColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            minimumSize: Size.fromHeight(65),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          hintStyle: TextStyle(fontSize: 16, color: greyColor),
          errorStyle: TextStyle(fontSize: 12, color: Colors.redAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: greyColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: greyColor.withOpacity(0.3), width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: greyColor.withOpacity(0.3), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primaryTintColor, width: 1.5),
          ),
        ),
        buttonColor: primaryColor,
        primaryColor: primaryColor,
        highlightColor: shift(primaryColor, .1),
        toggleableActiveColor: primaryColor);
  }

  Color shift(Color c, double amt) {
    amt *= (isDark ? -1 : 1);
    var hslc = HSLColor.fromColor(c); // Convert to HSL
    double lightness =
        (hslc.lightness + amt).clamp(0, 1.0) as double; // Add/Remove lightness
    return hslc.withLightness(lightness).toColor(); // Convert back to Color
  }

  static changeTheme(ThemeType type) {
    final theme = AppTheme.fromType(type);
    if (theme.isDark) {
      lightTheme = theme;
    } else {
      darkTheme = theme;
    }
  }

  static AppTheme get theme =>
      LocaleStorage.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  static AppTheme lightTheme = AppTheme.fromType(ThemeType.LIGHT_GREEN);
  static AppTheme darkTheme = AppTheme.fromType(ThemeType.DARK_GREEN);
}
