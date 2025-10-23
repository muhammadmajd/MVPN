


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

import '../common/widgets/drawer/list_tile.dart';
import '../common/widgets/languages/langauge_change.dart';
import '../data/repositories/user/user_repository.dart';
import '../data/services/user_global.dart';
import '../features/authontication/screens/login/login.dart';
import '../features/authontication/screens/password_configaration/change_password.dart';
import '../features/authontication/screens/signup/signup.dart';
import '../features/authontication/screens/signup/verify_email.dart';
import '../features/personalization/screens/profile/profile.dart';
import '../helpers/ad_helper.dart';
import '../helpers/config.dart';
import '../utils/constents/colors.dart';
import '../utils/helper/helper_functions.dart';
import '../widgets/about_dialog.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserRepository.instance;


    final dark = THelperFunctions.isDarkMode(context);
    return Drawer(

        child: Container(
            color:dark? Colors.black.withOpacity(0.9):  Colors.white.withOpacity(0.9),
            //color: design.barColor,
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: InkWell(
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left:65.0, right: 65),
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  //color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),

                                  image: DecorationImage(
                                    image: AssetImage("assets/images/logo.png"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Text(' ')
                            ),
                          )),
                      onTap: (){
                        // webController.scaffoldKey11.currentState?.closeDrawer();
                        Get.to(()=> HomeScreen());
                        // Navigator.pushNamed(context, Homepage.ROUTE_ID);
                      },
                    ),
                  ),

                  ListTileItem(name: tr('language') ,icon: Icon (Iconsax.language_circle,color: dark?Colors.white : Colors.grey, ) ,
                      onTap:() {


                      AdHelper.showRewardedAd(onComplete: () {
                        Get.to(()=>  LanguageView());
                      });


                  }

                  ),






                  UserGlobal.authUser.token!=''? ListTileItem(name: tr('profile') ,icon: Icon (Iconsax.presention_chart1,color: dark?TColors.light: TColors.dark, )
                      ,onTap:() {

                       // Get.offAll(() => const WebViewScreen());

                      }):ListTileItem(name: tr('createAccount') ,icon: Icon (Iconsax.edit,color: dark?TColors.light: TColors.dark, )
                      ,onTap:()=>Get.to(()=>  SignupScreen())),

                  UserGlobal.authUser.token!=''? ListTileItem(name: tr('updateProfile') ,
                      icon: Icon (Iconsax .user_edit,color: dark?TColors.light: TColors.dark,)
                      ,onTap:(){

                        Get.offAll(() => const ProfileScreen());
                      }):Container(),

                  UserGlobal.authUser.token!=''? ListTileItem(name: tr('changePassword') ,icon: Icon (Iconsax .user_edit,color: dark?TColors.light: TColors.dark, )
                      ,onTap:()=>Get.to(()=>  ChangePasswordScreen())):Container(),
                  if (UserGlobal.authUser.token!='' && UserGlobal.authUser.activeAccount=='0')
                    ListTileItem(name: tr('activateAccount') ,icon: Icon (Iconsax .activity,color: dark?TColors.light: TColors.dark, )
                        ,onTap:()=>Get.offAll(()=>  VerifyEmailScreen(email: UserGlobal.authUser.email))) else Container(),


                  UserGlobal.authUser.token==''? ListTileItem(name: tr('login') ,icon: Icon (Iconsax .login,color: dark?TColors.light: TColors.dark, )
                      ,onTap:()=>Get.offAll(()=>  LoginScreen()))
                      :ListTileItem(name: tr('logout') ,icon: Icon (Iconsax .logout,color: dark?TColors.light: TColors.dark, )
                      ,onTap:()=>controller.logout()),

                  ListTileItem(name: tr('about') ,icon: Icon (Iconsax .info_circle,color: dark?TColors.light: TColors.dark, )
                      ,onTap:(){

                        AdHelper.showInterstitialAd(onComplete: () async {
                          Get.dialog(AboutMVPNDialog());
                        });
                   // Get.dialog(AboutMVPNDialog());
                  })



                  // ListTileItem(name: 'Profile' ,icon: Icon (Iconsax .user_edit,color: TColors.dark, ) ,onTap:()=>Get.to(()=>const  WebViewScreen(url: "https://alnashra.org/karna/trial/site/english/index.php?node=93&cat_id=1"),)),
                ])));
  }
}




