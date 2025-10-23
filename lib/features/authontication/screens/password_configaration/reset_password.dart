import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constents/sizes.dart';
import '../../../../utils/constents/text_strings.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../../utils/constents/image_strings.dart';
import '../login/login.dart';
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()=>Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body:  SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace,),
        child: Column(
          children: [
            /// Images
            Image (image: const AssetImage (TImages.deliveredEmailIllustration), width: THelperFunctions.screenWidth() * 0.6),
            const SizedBox (height : TSizes.spacesBtwsections),
            /// Title & Subtitle
            Text(TTexts.changeYourPasswordTitle, style: Theme.of (context). textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox (height: TSizes.spacesBtwsections),
            Text (TTexts.changeYourPasswordSubTitle, style: Theme.of (context). textTheme.labelMedium, textAlign: TextAlign.center),
            const SizedBox (height: TSizes.spacesBtwsections),
            /// Buttons
        SizedBox(
          width: double. infinity,
          child: ElevatedButton (onPressed:()=> Get.to(()=>const LoginScreen()), child: const Text (TTexts.done)),
        ),
            const SizedBox (height: TSizes.spacesBtwsections),
            /// Buttons
            SizedBox(
              width: double. infinity,
              child: TextButton (onPressed:()=> Get.to(()=>const LoginScreen()), child: const Text (TTexts.resendEmail)),
            )
          ],
        ),),
      ),
    );
  }
}
