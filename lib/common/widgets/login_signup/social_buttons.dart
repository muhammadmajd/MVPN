
import 'package:flutter/material.dart';

import '../../../utils/constents/colors.dart';
import '../../../utils/constents/image_strings.dart';
import '../../../utils/constents/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final controller =Get.put(LoginController());
    //final controller =LoginController.instance;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container (
              decoration: BoxDecoration(border: Border. all (color: TColors.grey), borderRadius: BorderRadius. circular (100)),
              child: IconButton (
                onPressed: () {},
                //onPressed: () => {}controller.googleSignIn()
                icon: const Image( width: TSizes.iconMd,

                  height: TSizes.iconMd,
                  image: AssetImage (TImages. google),
                ),
              )
          ),
          const SizedBox (width: TSizes.spaceBtwItems),
          Container (
              decoration: BoxDecoration(border: Border.all (color: TColors.grey),
                  borderRadius: BorderRadius.circular (100)),
              child: IconButton (
                onPressed: () {},
                icon: const Image( width: TSizes.iconMd,

                  height: TSizes.iconMd,
                  image: AssetImage (TImages.facebook),
                ),
              )
          ),
        ]
    );
  }
}