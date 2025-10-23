import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constents/sizes.dart';
import '../../../../../utils/constents/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/profile_controller.dart';

class TProfileForm extends StatelessWidget {
  const TProfileForm({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    final controller =Get.put(ProfileController());

    return Form(
        key: controller.profileFormKey,

        child: Column(

          children: [
            /// First & Last Name
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value)=> TValidator.validateEmptyText(tr('fname'), value),

                    decoration: const InputDecoration(
                        labelText: TTexts.firstName, prefixIcon: Icon(Iconsax.user)
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields,),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value)=> TValidator.validateEmptyText(tr('lname'), value),
                    decoration: const InputDecoration(
                        labelText: TTexts.lastName, prefixIcon: Icon(Iconsax.user)
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields,),
            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value)=> TValidator.validateEmail( value),
              decoration:   InputDecoration(
                  labelText:tr('email'), prefixIcon: Icon(Iconsax.direct)
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields,),
            /// Phone Number
            TextFormField(
              //validator: (value)=> TValidator.validatePhoneNumber( value),
              controller: controller.phoneNumber,
              decoration:   InputDecoration(
                  labelText: tr('phone'), prefixIcon: Icon(Iconsax.call)
              ),
            ),


            const SizedBox(height: TSizes.spacesBtwsections,),
            SizedBox(width: double.infinity,
              child: ElevatedButton  (
                  onPressed: ()=>controller.updateProfile(),
                  child:  Text(tr('updateProfile'))),)
          ],
        ));
  }
}

