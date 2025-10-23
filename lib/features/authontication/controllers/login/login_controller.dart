
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

import '../../../../common/widgets/web_view/web_view_controller.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../data/services/user_global.dart';

import '../../../../utils/check_internet/network_manager.dart';
import '../../../../utils/constents/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../screens/signup/verify_email.dart';
class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage ();
  final email = TextEditingController ();
  final password = TextEditingController ();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState> ();
  final useRepository = UserRepository.instance;


  @override
  void onInit() {
    try{
      email.text = localStorage.read ('REMEMBER_ME_EMAIL');
      password. text = localStorage. read ('REMEMBER_ME_PASSWORD') ;
    } catch(e)
    {
      // TLoaders. errorSnackBar(title: 'Oh Snap', message: e.toString());
    }

    super.onInit();
  }

  /// - - Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try{
      print(email.text.trim());
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.loadingJdon);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected() ;
      if (!isConnected) {
        //TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        //TFullScreenLoader.stopLoading();
        return;
      }
      /// Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using EMail & Password Authentication

      final userAuth = await useRepository.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      if(userAuth.token!='')
        {
         TFullScreenLoader.stopLoading();
        /* localStorage.write('token', userCredentials.token);
         localStorage.write('username', userCredentials.username);
         localStorage.write('email', userCredentials.email);
         localStorage.write('fname', userCredentials.firstName);
         localStorage.write('lname', userCredentials.lastName);*/
         useRepository.saveUser(userAuth);
        // UserGlobal.authUser = userAuth;
         print('user:' +UserGlobal.authUser.username);
         print('user:' +UserGlobal.authUser.token);//22::2::c19cf4b32a13f4697c970f4fe91672c0
         // muhammad user: 23::2::31ef51ff8d52982ae585cdc9cc65df38
         print(UserGlobal.authUser.token);

         /*final webController =WebController.instance;
         webController.clearWebViewCache();
         webController.scaffoldKey11.currentState?.closeDrawer();*/
        // webController.resetController();
        // var navigationController =NavigationController.instance;
        // navigationController.selectedIndex.value=0;
        // navigationController.refresh();
         if(userAuth.activeAccount=="0")
           {
             TLoaders. errorSnackBar(title: tr('activateAccount'), message: tr('activateAccountMessage'));
             Get.to(()=>  VerifyEmailScreen(email: email.text.trim(),));
           }
          else{
            Get.offAll(()=>   HomeScreen());
          }

        }
      else
        {
          TFullScreenLoader.stopLoading();
          TLoaders. errorSnackBar(title: 'Oh Snap', message: 'Username or passwor is inccorect');
        }
      // Remove Loader
      //TFullScreenLoader.stopLoading();
      // Redirect
      //AuthenticationRepository.instance.screenRedirect();
      // Get.to(()=> const SignupScreen())
    } catch(e)
    {
      print(e.toString());
      TFullScreenLoader.stopLoading();
      //TLoaders. errorSnackBar(title: 'Oh Snap', message: e.toString());

    } finally{
     // TFullScreenLoader.stopLoading();
    }
  }






}