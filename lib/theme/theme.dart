import 'package:briefing/theme/colors.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: themeAppIndigo,
    primaryColor: themeAppWhite100,
    primaryColorBrightness: Brightness.light,
    bottomAppBarColor: themeAppWhite100,
    buttonTheme: base.buttonTheme.copyWith(
        buttonColor: themeAppWhite100, textTheme: ButtonTextTheme.normal),
    scaffoldBackgroundColor: themeAppBackgroundWhite,
    cardColor: themeAppBackgroundWhite,
    textSelectionColor: themeAppGrey600,
    errorColor: themeAppErrorRed,
    canvasColor: Colors.transparent,
    textTheme: _buildAppTextTheme(base.textTheme),
    primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildAppTextTheme(base.accentTextTheme),
    accentIconTheme: base.accentIconTheme.copyWith(color: themeAppIndigo),
    primaryIconTheme: base.iconTheme.copyWith(color: themeAppGrey600),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    iconTheme: base.iconTheme.copyWith(color: themeAppGrey700),
  );
}

TextTheme _buildAppTextTheme(TextTheme base) {
  return base
      .copyWith(
          title: base.title.copyWith(
              fontFamily: 'Libre_Franklin',
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
          subhead: base.subhead.copyWith(
            fontFamily: 'Crimson_Text',
            fontSize: 18.0,
          ),
          caption: base.caption.copyWith(fontFamily: 'Libre_Franklin'),
          button: base.button.copyWith(fontFamily: 'Libre_Franklin'),
          subtitle: base.subtitle.copyWith(
            fontFamily: 'Libre_Franklin',
            fontSize: 14.0,
          ))
      .apply(
          fontFamily: 'Crimson_Text',
          displayColor: themeAppGrey800,
          bodyColor: themeAppGrey800);
}
