
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
class PasswordController extends GetxController {
  static PasswordController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final hideNewPassword = true.obs;
  final password = TextEditingController ();
  final newPassword = TextEditingController ();
  final confirmPassword = TextEditingController ();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState> ();
  final useRepository = UserRepository.instance;


  @override
  void onInit() {

    super.onInit();
  }

  /// - - Email and Password SignIn
  Future<void> changePassword() async {
    try{
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.loadingJdon);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected() ;
      if (!isConnected) {
        //TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!passwordFormKey.currentState!.validate()) {
        //TFullScreenLoader.stopLoading();
        return;
      }

      // Login user using EMail & Password Authentication

      final userAuth = await useRepository.changePassword( password.text.trim(),  newPassword.text.trim(),  confirmPassword.text.trim());
      if(userAuth.token!='')
      {
        TFullScreenLoader.stopLoading();

        print('user:' +UserGlobal.authUser.username);
        print('user:' +UserGlobal.authUser.token);//22::2::c19cf4b32a13f4697c970f4fe91672c0
        // muhammad user: 23::2::31ef51ff8d52982ae585cdc9cc65df38
        print(UserGlobal.authUser.token);


        TLoaders.successSnackBar(title:'Success', message: UserGlobal.message);
        Get.to(()=>   HomeScreen());
      }
      else
      {
        TFullScreenLoader.stopLoading();
        TLoaders. errorSnackBar(title: tr('titleError'), message: UserGlobal.message);
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