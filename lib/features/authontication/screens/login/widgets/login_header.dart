import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constents/image_strings.dart';
import '../../../../../utils/constents/sizes.dart';
import '../../../../../utils/constents/text_strings.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
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
        Text(tr('loginTitle'),style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox (height: TSizes.sm),
        Text( tr('loginSubTitle'),style: Theme.of(context).textTheme.bodyMedium,),
      ],
    );
  }
}

