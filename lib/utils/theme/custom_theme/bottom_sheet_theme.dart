

import 'package:flutter/material.dart';

class TBottomSheetTheme{
  TBottomSheetTheme._();
  static BottomSheetThemeData lightAppBArTheme = BottomSheetThemeData(
    elevation: 0,
    showDragHandle: true,
    modalBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    constraints: const BoxConstraints(  minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),

  );
  static BottomSheetThemeData darkAppBArTheme = BottomSheetThemeData(
    elevation: 0,
    showDragHandle: true,
    modalBackgroundColor: Colors.black,
    backgroundColor: Colors.black,
    constraints: const BoxConstraints(  minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),

  );
}