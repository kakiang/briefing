import 'package:briefing/colors.dart';
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      accentColor: themeAppGrey800,
      primaryColor: themeAppWhite100,
      primaryColorBrightness: Brightness.light,
      bottomAppBarColor: themeAppWhite100,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: themeAppWhite100,
        textTheme: ButtonTextTheme.normal,
      ),
      
      scaffoldBackgroundColor: themeAppBackgroundWhite,
      cardColor: themeAppBackgroundWhite,
      textSelectionColor: themeAppGrey600,
      errorColor: themeAppErrorRed,
      canvasColor: Colors.transparent,
      textTheme: _buildAppTextTheme(base.textTheme),
      primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildAppTextTheme(base.accentTextTheme),
      accentIconTheme:IconThemeData().copyWith(color: Colors.blue),
      primaryIconTheme: base.iconTheme.copyWith(color: themeAppGrey800),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
//        border: CutCornersBorder(),
      ),
      iconTheme: IconThemeData().copyWith(
        color: themeAppGrey700,
      ));
}

TextTheme _buildAppTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        //themeAppGrey600
        subtitle: base.subtitle.copyWith(
          color: themeAppGrey600,
          fontWeight: FontWeight.w400,
        ),
        title: base.title.copyWith(fontSize: 22.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        // fontFamily: 'Rubik',
        displayColor: themeAppGrey800,
        bodyColor: themeAppGrey800,
      );
}
