

import 'package:flutter/material.dart';

class TAppBarTheme{
  TAppBarTheme._();
  static const AppBarTheme lightAppBArTheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black, size: 24),
      actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
      titleTextStyle:  TextStyle(fontSize: 18,color: Colors.black, fontWeight: FontWeight.w600),

  );
  static const AppBarTheme darkAppBArTheme  = AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black, size: 24),
        actionsIconTheme: IconThemeData(color: Colors.white, size: 24),
        titleTextStyle:  TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.w600),

  );
}