import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constents/image_strings.dart';
import '../../../../../utils/constents/sizes.dart';

class TChangePasswordHeader extends StatelessWidget {
  const TChangePasswordHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: [
        SizedBox(height: TSizes.defaultSpace,),
        Center(
          child: Image(image: AssetImage(dark?TImages.darkAppLogo: TImages.lightAppLogo),
            height: 200,),
        ),
        Text(tr('changeYourPasswordTitle'),style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox (height: TSizes.sm),
        Text( tr('changeYourPasswordSubTitle'),style: Theme.of(context).textTheme.bodyMedium,),
      ],
    );
  }
}