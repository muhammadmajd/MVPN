
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constents/colors.dart';
import '../../../../../utils/constents/sizes.dart';
import '../../../../../utils/constents/text_strings.dart';
import '../../../../../utils/helper/helper_functions.dart';

class TTermAndCondition extends StatelessWidget {
  const TTermAndCondition({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row( children: [

      SizedBox (width: 24, height: 24, child: Checkbox (value: true, onChanged: (value) {}),),
      const SizedBox(width: TSizes.spaceBtwItems),
      Expanded(
        child: Text.rich(
          TextSpan (children: [
            TextSpan (text: '${tr('iAgreeTo')} ', style: Theme.of (context). textTheme.headlineSmall),//
            TextSpan (text: '${tr('privacyPolicy')} ', style: Theme.of(context).textTheme.headlineSmall!.apply (
              color: dark ? TColors.white : TColors.primary, decoration: TextDecoration.underline,
              decorationColor: dark ? TColors.white : TColors.primary,
            )),
            TextSpan (text: '${tr('and')} ', style:  Theme.of(context).textTheme.headlineSmall),
            TextSpan (text: tr('termsofUse'), style: Theme.of(context).textTheme.headlineSmall!.apply(
              color: dark ? TColors.white: TColors.primary, decoration: TextDecoration.underline,
              decorationColor: dark ? TColors.white : TColors.primary,
            )),

          ]),

        ),
      ),

    ]);
  }
}
