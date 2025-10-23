import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/password/password_controller.dart';

import '../../../../../utils/constents/sizes.dart';

class TChangePasswordForm extends StatelessWidget {
  const TChangePasswordForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(PasswordController());
    return Form (
        key: controller.passwordFormKey,
        child:
        Padding(

          padding: const EdgeInsets.symmetric(vertical: TSizes.spacesBtwsections),
          child: Column(
            children: [

              /// Old Password
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
              const SizedBox (height: TSizes.spaceBtwInputFields),
              /// New Password
              Obx(
                    ()=> TextFormField(
                  //validator: (value)=> TValidator.validatePassword( value),
                  controller: controller.newPassword,
                  obscureText: controller.hideNewPassword.value,
                  decoration: InputDecoration(
                      labelText: tr('password'),
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                          onPressed: ()=> controller.hideNewPassword.value= !controller.hideNewPassword.value,
                          icon:  Icon(controller.hideNewPassword.value? Iconsax.eye_slash : Iconsax.eye))
                  ),
                ),
              ),
              const SizedBox (height: TSizes.spaceBtwInputFields),
              /// Confirm Password
              Obx(
                    ()=> TextFormField(
                  //validator: (value)=> TValidator.validatePassword( value),
                  controller: controller.confirmPassword,
                  obscureText: controller.hideConfirmPassword.value,
                  decoration: InputDecoration(
                      labelText: tr('password'),
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                          onPressed: ()=> controller.hideConfirmPassword.value= !controller.hideConfirmPassword.value,
                          icon:  Icon(controller.hideConfirmPassword.value? Iconsax.eye_slash : Iconsax.eye))
                  ),
                ),
              ),
              const  SizedBox (height: TSizes.spaceBtwInputFields /2),


              const  SizedBox (height: TSizes.spacesBtwsections),
              /// Sign In Button
              SizedBox (width: double.infinity, child: ElevatedButton(onPressed: ()=>controller.changePassword(),
                  child:  Text (tr('continue')))),



            ],
          ),
        )
    );
  }
}
