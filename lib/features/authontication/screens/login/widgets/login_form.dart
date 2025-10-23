import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/login/login_controller.dart';
import '../../password_configaration/forget_password.dart';


import '../../../../../utils/constents/sizes.dart';
import '../../../../../utils/constents/text_strings.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final controller =Get.put(LoginController());
    final controller = Get.put(LoginController());
    return Form (
        key: controller.loginFormKey,
        child:
        Padding(

          padding: const EdgeInsets.symmetric(vertical: TSizes.spacesBtwsections),
          child: Column(
            children: [
              /// Email
              TextFormField(
                  controller: controller.email,
                  //validator: (value) => TValidator.validateEmptyText(value),
                  decoration:  InputDecoration (prefixIcon: Icon (Iconsax.direct_right), labelText: tr('username'))),
              const SizedBox (height: TSizes.spaceBtwInputFields),
              /// Password
              Obx(
                    ()=> TextFormField(
                  //validator: (value)=> TValidator.validatePassword( value),
                  controller: controller.password,
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                      labelText: tr('password'),
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                          onPressed: ()=> controller.hidePassword.value= !controller.hidePassword.value,
                          icon:  Icon(controller.hidePassword.value? Iconsax.eye_slash : Iconsax.eye))
                  ),
                ),
              ),
              const  SizedBox (height: TSizes.spaceBtwInputFields /2),
              /// Remember me & Forget password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Remember me
                  Row(
                    children: [
                      Obx(()=> Checkbox(value: controller.rememberMe.value,
                          onChanged: (value)=>controller.rememberMe.value = !controller.rememberMe.value)),
                       Text(tr('rememberMe'))
                    ],
                  ),
                  /// Forget Password

                  TextButton(onPressed:  () =>Get.to(()=> const ForgetPasswordScreen()), child:  Text(tr('forgetPassword')))

                ],
              ),

              const  SizedBox (height: TSizes.spacesBtwsections),
              /// Sign In Button
              SizedBox (width: double.infinity, child: ElevatedButton(
                  onPressed: () {
                    controller.emailAndPasswordSignIn();
                  },
                  child:  Text (tr('login')))),
              const  SizedBox (height: TSizes.spaceBtwItems),
              /// Create  Account Button
              SizedBox (width: double.infinity, child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.grey[300]), // Set the background color
                    foregroundColor: WidgetStateProperty.all(Colors.white), // Set the text color
                  ),
                  //onPressed: () => controller.emailAndPasswordSignIn(),
                  onPressed: () => Get.to(const SignupScreen()),
                  child:  Text (tr('createAccount')))),


            ],
          ),
        )
    );
  }
}
