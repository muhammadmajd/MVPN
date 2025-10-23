import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vpn_basic_project/utils/theme/theme.dart';

import 'bindings/general_bindinds.dart';
import 'helpers/ad_helper.dart';
import 'helpers/config.dart';
import 'helpers/pref.dart';
import 'screens/splash_screen.dart';

//global object for accessing device screen size
late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  //firebase initialization
  await Firebase.initializeApp();

  //initializing remote config
  await Config.initConfig();

  await Pref.initializeHive();

  await AdHelper.initAds();
  //for setting orientation to portrait only

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((v) {
    //runApp(const MyApp());
    runApp(
      EasyLocalization(
          //assetLoader: RootBundleAssetLoader(),
          //supportedLocales: EasyLocalization.of(context)!.supportedLocales!,
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/translations', // <-- change the path of the translation files
          fallbackLocale: Locale('en'),
          child: MyApp()
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MVpn',
      initialBinding: GeneralBindings(),
      home: SplashScreen(),
      localizationsDelegates: context.localizationDelegates,
      //supportedLocales: context.supportedLocales,

      supportedLocales: EasyLocalization.of(context)!.supportedLocales!,
      locale: EasyLocalization.of(context)!.locale,
      //theme
      /*theme: ThemeData(
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 3),
        useMaterial3: false,
      ),*/
      theme: TAppTheme.lightTheme,
      themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      //themeMode: ThemeMode.system,
      darkTheme: TAppTheme.darkTheme,

      //dark theme
      /*darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: false,
          appBarTheme: AppBarTheme(centerTitle: true, elevation: 3)),*/

      debugShowCheckedModeBanner: false,
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Pref.isDarkMode ? Colors.white70 : Colors.black54;
  Color get bottomNav => Pref.isDarkMode ? Colors.white12 : Colors.blue;
}
