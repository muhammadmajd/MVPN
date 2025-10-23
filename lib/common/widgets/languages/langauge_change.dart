import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import '../../../data/services/user_global.dart';
import '../../../utils/helper/helper_functions.dart';

class LanguageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "MVPN",
          //style: TextStyle(color: Colors.black),
        ),
        //backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        //color: Colors.white,
        color:dark? Colors.black.withOpacity(0.9):  Colors.white.withOpacity(0.9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 26),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                "Language Menu",
                style: TextStyle(
                  color: Color.fromARGB(255, 166, 166, 166),
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 25),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                "language",
              ),
            ),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: "عربي",
                subtitle: "عربي",
                locale: Locale("ar")),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: "English",
                subtitle: "English",
                locale: Locale("en")),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  Container buildDivider() => Container(
    margin: EdgeInsets.symmetric(
      horizontal: 24,
    ),
    child: Divider(
      color: Colors.grey,
    ),
  );

  Container buildSwitchListTileMenuItem(
      {required BuildContext context, String title='', String subtitle='', Locale? locale}) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: ListTile(
          dense: true,
          // isThreeLine: true,
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
          ),
          onTap: () {
            log(locale.toString(), name: this.toString());
           // print('locale!.languageCode');
           // print(locale!.languageCode);
           // print(EasyLocalization.of(context)?.locale.languageCode);
            UserGlobal.lang=locale!.languageCode;
            EasyLocalization.of(context)?.locale!=locale;
            if( UserGlobal.lang=='ar')
            {
              UserGlobal.url_prefix="https://alnashra.org/karna/trial/site/arabic/";
              context.setLocale(Locale('ar'));
            }else {
              UserGlobal.url_prefix="https://alnashra.org/karna/trial/site/english/";
              context.setLocale(Locale('en'));
            }

            //context.setLocale(locale!);
            Get.updateLocale(locale!);


          }),
    );
  }
}