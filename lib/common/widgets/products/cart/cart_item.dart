import 'package:flutter/material.dart';

import '../../../../utils/constents/colors.dart';
import '../../../../utils/constents/image_strings.dart';
import '../../../../utils/constents/sizes.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../images/t_roundes_image.dart';
import '../../texts/product_title_text.dart';
import '../../texts/t_brand_title_text_with_verified.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(

      children: [
        /// Image
        TRoundedImage (
          imageUrl: TImages.promoBanner1,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes. sm),
          backgroundColor: THelperFunctions.isDarkMode (context) ? TColors. darkerGrey : TColors.light,
        ),
        const SizedBox (width: TSizes .spaceBtwItems),
        /// Title, Price & Size
        ///
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment. start,
            children: [
              const TBrandTitleWithVerifiedIcon(title: 'Nike'),
              const TProductTitleText (title: 'Black Sports shoes sabdk babskaj bsdfik absk',  maxLines: 1),
              /// Attributes
              Text.rich(TextSpan(
                  children: [
                    TextSpan(text: 'Color', style: Theme.of (context). textTheme. bodySmall),
                    TextSpan (text: 'Green', style: Theme.of (context). textTheme. bodyLarge),
                    TextSpan(text: 'Size ', style: Theme.of (context) .textTheme .bodySmall),
                    TextSpan (text: 'UK 08', style: Theme.of (context). textTheme .bodyLarge),

                  ]
              )
              )
            ],
          ),
        )

      ],
    );
  }
}
