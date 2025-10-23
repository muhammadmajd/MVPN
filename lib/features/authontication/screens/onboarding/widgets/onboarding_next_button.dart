
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../../utils/constents/colors.dart';
import '../../../../../utils/constents/sizes.dart';
import '../../../../../utils/device/device_utality.dart';
import '../../../../../utils/helper/helper_functions.dart';
import '../../../controllers/controllers.onboarding/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark =THelperFunctions.isDarkMode(context);
    return Positioned (

        right: TSizes.defaultSpace,
        bottom: TDeviceUtils.getBottomNavigationBarHeight(),

        child: ElevatedButton(
          onPressed: ()=>OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(shape: const CircleBorder(),
              backgroundColor: dark? TColors.primary: Colors.black),
          child: const Icon(Iconsax.arrow_right_3),
        )
    );
  }
}

