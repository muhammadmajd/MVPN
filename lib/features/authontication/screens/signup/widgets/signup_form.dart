import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constents/sizes.dart';
import '../../../../../utils/constents/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';
import '../verify_email.dart';
import 'term_and_conditions.dart';
class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    final controller =Get.put(SignupController());

    return Form(
        key: controller.signupFormKey,

        child: Column(

          children: [
            /// First & Last Name
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value)=> TValidator.validateEmptyText('First name', value),

                    decoration:   InputDecoration(
                        labelText: tr('fname'), prefixIcon: Icon(Iconsax.user)
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields,),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value)=> TValidator.validateEmptyText('Last name', value),
                    decoration:  InputDecoration(
                        labelText: tr('lname') ,prefixIcon: Icon(Iconsax.user)
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields,),
            /// Username
            TextFormField(
              controller: controller.username,
              validator: (value)=> TValidator.validateEmptyText('Username', value),
              decoration:  InputDecoration(
                  labelText: tr('username'), prefixIcon: Icon(Iconsax.user_edit)
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields,),
            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value)=> TValidator.validateEmail( value),
              decoration:  InputDecoration(
                  labelText: tr('email'), prefixIcon: Icon(Iconsax.direct)
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields,),
            /// Phone Number
            TextFormField(
              //validator: (value)=> TValidator.validatePhoneNumber( value),
              controller: controller.phoneNumber,
              decoration:  InputDecoration(
                  labelText: tr('phone'), prefixIcon: Icon(Iconsax.call)
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields,),
            /// Password
            Obx(
                  ()=> TextFormField(
                //validator: (value)=> TValidator.validatePassword( value),
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                    labelText:  tr('password'),
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                        onPressed: ()=> controller.hidePassword.value= !controller.hidePassword.value,
                        icon:  Icon(controller.hidePassword.value? Iconsax.eye_slash : Iconsax.eye))
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields,),
            /// Terms&Conditions Checkbox
            const TTermAndCondition(),
            const SizedBox(height: TSizes.spacesBtwsections,),
            SizedBox(width: double.infinity,
              child: ElevatedButton  (
                  onPressed: ()=>controller.signup(),
                  child:  Text(tr('createAccount'))),)
          ],
        ));
  }
}

