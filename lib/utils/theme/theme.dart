
import 'package:flutter/material.dart';

import 'custom_theme/appBar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/checkBox_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_Button_Theme.dart';
import 'custom_theme/outline_button_theme.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class TAppTheme
{
  TAppTheme._();
  static ThemeData lightTheme= ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextThem,
      chipTheme: TChipTheme.lightChipTheme,
      appBarTheme: TAppBarTheme.lightAppBArTheme,
      checkboxTheme: TCheckBoxTheme.lightAppBArTheme,
      bottomSheetTheme: TBottomSheetTheme.lightAppBArTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme

  );

 /* static ThemeData lightTheme1 = ThemeData(
      useMaterial3: true, fontFamily: 'Poppins',

      brightness: Brightness.light, primaryColor: Colors.blue,
      textTheme: TTextTheme.lightTextThem,
      chipTheme: TChipTheme.lightChipTheme, scaffoldBackgroundColor: Colors.white,
      appBarTheme: TAppBarTheme.lightAppBArTheme, checkboxTheme: TCheckBoxTheme.lightAppBArTheme,
      bottomSheetTheme: TBottomSheetTheme.lightAppBArTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme
  ) ;*/
  static ThemeData darkTheme= ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TTextTheme.darkTextThem,
      chipTheme: TChipTheme.darkChipTheme,
      appBarTheme: TAppBarTheme.darkAppBArTheme,
      checkboxTheme: TCheckBoxTheme.darkAppBArTheme,
      bottomSheetTheme: TBottomSheetTheme.darkAppBArTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme
  );
}