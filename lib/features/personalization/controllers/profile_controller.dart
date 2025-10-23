
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../data/services/user_global.dart';
import '../../../../utils/check_internet/network_manager.dart';
import '../../../../utils/constents/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../common/widgets/web_view/web_view_controller.dart';



class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  /// Variables
  final email = TextEditingController(); // Controller for email input
  final lastName = TextEditingController(); // Controller for last name input
  final username = TextEditingController(); // Controller for username input

  final firstName = TextEditingController(); // Controller for first name input
  final phoneNumber = TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState> (); // Form key for form validation


  final useRepository = UserRepository.instance;

  @override
  void onInit() {
    print("xxx");
    print(UserGlobal.authUser.email);
    email.text=UserGlobal.authUser.email;
    firstName.text=UserGlobal.authUser.firstName;
    lastName.text=UserGlobal.authUser.lastName;
    phoneNumber.text=UserGlobal.authUser.phoneNumber;
    super.onInit();
  } //final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  /// - - SIGNUP
  ///

  //Future<void> signup() async {
  void updateProfile() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('We are processing your information...', TImages.successJson);

      // Check Internet Connectivity
 print( UserGlobal.userName);

      // Form Validation
     /* if(!profileFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();

        return;
      }*/

      // Privacy Policy Check

      // Register user in the Firebase Authentication & Save user data in the Firebase
      bool registerResult= await useRepository.updateProfile(
        email.text.trim(),
       UserGlobal.authUser.username,
        firstName.text. trim(),
        lastName.text. trim(),
        'sy',
        phoneNumber.text.trim(),
      );
      //{"message":"Password length - minimum 5 chars","error_code":"1003","status":"false"}
      // Save Authenticated user data in the Firebase Firestore
      if(registerResult){

        UserGlobal.userName=username.text.trim();

        TFullScreenLoader.stopLoading();
        // Show Success Message
        TLoaders.successSnackBar (title: 'Congratulations', message: 'Your profile has been updated Successfully.');

        //webController.scaffoldKey11.currentState?.closeDrawer();

        // Move to Verify Email Screen
        Get.offAll(()=>  HomeScreen( ));}
      else{

        TFullScreenLoader.stopLoading();
        //Show some Generic Error to the user
        TLoaders.errorSnackBar (title: 'Oh Snap!', message: UserGlobal.message);
      }
      // Get.to(()=> const LoginScreen());
    }catch (e) {
      TFullScreenLoader.stopLoading();
      //Show some Generic Error to the user
      TLoaders.errorSnackBar (title: 'Oh Snap!', message: e.toString());
    }finally {
      // Remove Loader
      //TFullScreenLoader.stopLoading();
    }

  }

}