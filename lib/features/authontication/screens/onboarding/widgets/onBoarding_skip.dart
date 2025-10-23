import 'package:flutter/material.dart';

import '../../../../../utils/device/device_utality.dart';
import '../../../controllers/controllers.onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: TDeviceUtils.getappbarheight(),
        child: TextButton(onPressed: ()=> OnBoardingController.instance.skipPage(), child: const Text('Skip')));
  }
}
