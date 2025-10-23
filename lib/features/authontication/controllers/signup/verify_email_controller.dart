
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../data/services/user_global.dart';

import '../../../../utils/constents/image_strings.dart';
import '../../../../utils/constents/text_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();
  final useRepository = UserRepository.instance;

  final code = TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> activateFormKey = GlobalKey<FormState> ();
  /// Send Email Whenever Verify Screen appears & Set Timer for auto redirect.
  @override
  void onInit(){
   // sendEmailVerification();
   // setTimerForAutoRedirect();
    super .onInit();
  }

  /// Send Email Verification link

  /*sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders. successSnackBar(title: 'Email Sent', message: 'Please Check your inbox and verify your email.');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(
        const Duration (seconds: 1),
            (timer) async {
          await FirebaseAuth. instance .currentUser?. reload() ;
          final user = FirebaseAuth.instance .currentUser;
          if (user?.emailVerified ?? false) {
            timer .cancel ();
            Get.off (
                  () => SuccessScreen(
                image: TImages.success1,
                title: TTexts.yourAccountCreatedTitle,
                subTitle: TTexts.yourAccountCreatedSubTitle,
                onPressed: () => AuthenticationRepository.instance.screenRedirect(),
              ),
            );
          }
        }
    );
  }
  /// Manually Check if Email Verified
  checkmailVerificationStatus()async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
            () => SuccessScreen (
            image: TImages.success1,
            title: TTexts.yourAccountCreatedTitle,
            subTitle: TTexts.yourAccountCreatedSubTitle,
            onPressed: ( )=> AuthenticationRepository.instance.screenRedirect()
        ),
      );

    }
  }*/

  sendEmailVerification(){}
  Future<void> emailVerification() async {
    try{
     // TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.loadingJdon);
      // Check Internet Connectivity


      // Login user using EMail & Password Authentication

      final userAuth = await useRepository.activate(UserGlobal.userName, code.text.trim(),'');

      if(userAuth.token.length>2)
      {

        //useRepository.saveUser(userAuth);
        UserGlobal.authUser = userAuth;

        //print(UserGlobal.authUser.token);
        Get.to(()=>    HomeScreen());
      }
      else
      {
        //TFullScreenLoader.stopLoading();
        TLoaders. errorSnackBar(title: 'Oh Snap', message: 'activated code is not  correct');
      }
      // Remove Loader
      //TFullScreenLoader.stopLoading();
      // Redirect
      //AuthenticationRepository.instance.screenRedirect();
      // Get.to(()=> const SignupScreen())
    } catch(e)
    {
     // TFullScreenLoader.stopLoading();
      //TLoaders. errorSnackBar(title: 'Oh Snap', message: e.toString());

    } finally{
      //TFullScreenLoader.stopLoading();
    }
  }



}
