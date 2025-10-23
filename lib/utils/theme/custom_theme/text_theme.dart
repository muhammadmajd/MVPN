
import 'package:flutter/material.dart';

class TTextTheme{
  TTextTheme._();
  static TextTheme lightTextThem=  const TextTheme(
    headlineLarge: TextStyle(fontSize: 32,color: Colors.black, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 20,color: Colors.black, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 10,color: Colors.black, fontWeight: FontWeight.w600),

    titleLarge: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.w400),

    bodyLarge: TextStyle(fontSize: 14,color: Colors.black, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14,color: Colors.black, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontSize: 10,color: Colors.black, fontWeight: FontWeight.w500),

    labelLarge: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.normal),
    labelMedium: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.normal),

  );
  static TextTheme darkTextThem=const TextTheme(
    headlineLarge: TextStyle(fontSize: 32,color: Colors.white, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 10,color: Colors.white, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w400),

    bodyLarge: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.w500),

    labelLarge: TextStyle(fontSize: 12,color: Colors.white, fontWeight: FontWeight.normal),
    labelMedium: TextStyle(fontSize: 12,color: Colors.white, fontWeight: FontWeight.normal),
  );


}
