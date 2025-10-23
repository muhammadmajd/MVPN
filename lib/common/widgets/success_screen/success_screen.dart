import 'package:flutter/material.dart';

import '../../../utils/constents/sizes.dart';
import '../../../utils/constents/text_strings.dart';
import '../../../utils/helper/helper_functions.dart';
import '../../styles/spacing_styles.dart';




class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, required this.onPressed});
  final String image,
      title,
      subTitle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: TSpacingStyle.paddingWithAppBarHeight *2,
        child: Column(

        children: [
          //TImages.deliveredEmailIllustration
          const SizedBox(height: TSizes.spacesBtwsections),
          const SizedBox(height: TSizes.spacesBtwsections),
          ///Image
          Image(image:  AssetImage(image),
              width: THelperFunctions.screenWidth() *0.6
          ),
          const SizedBox(height: TSizes.spacesBtwsections),

          /// Title & subTitle
          /// //TImages.deliveredEmailIllustration, TTexts.yourAccountCreatedTitle, TTexts.yourAccountCreatedSubTitle
          Text (title, style: Theme.of(context). textTheme. headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: TSizes .spaceBtwItems),
          //TTexts.yourAccountCreatedSubTitle
          Text (subTitle, style: Theme.of (context) .textTheme.labelLarge, textAlign: TextAlign.center),
          const SizedBox (height: TSizes.spaceBtwItems),

          ///  Buttons
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onPressed,
              child: const Text (TTexts.tContinue))),
          //               const SizedBox(height: TSizes.spaceBtwItems),
        ],
        ),
        ),

      ),
    );
  }
}
