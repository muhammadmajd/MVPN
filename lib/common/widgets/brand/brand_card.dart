import 'package:flutter/material.dart';

import '../../../utils/constents/colors.dart';
import '../../../utils/constents/enums.dart';
import '../../../utils/constents/image_strings.dart';
import '../../../utils/constents/sizes.dart';
import '../../../utils/helper/helper_functions.dart';
import '../custom_shapes/container/rounded_container.dart';
import '../images/t_circular_image.dart';
import '../texts/t_brand_title_text_with_verified.dart';

class TBrandCard extends StatelessWidget {
  const TBrandCard({
    super.key,
    required this.showBorder,
    this.onTap,
  });

  final bool showBorder;
  final void Function ()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.sm),
        showBorder: showBorder,
        backgroundColor:  Colors.transparent,
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// -- Icon
            Flexible(
              child: TCircularImage(
                //width: 30,
                //height: 30,
                isNetworkImage: false,
                image: TImages.clothIcon,
                backgroundColor: Colors. transparent,
                overlayColor: THelperFunctions.isDarkMode (context) ? TColors.white
                    : TColors.black, ),
            ),
            // TCircularImage
            const SizedBox(width: TSizes.spaceBtwItems / 2),

            /// -- Text
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const TBrandTitleWithVerifiedIcon(title: 'Nike',brandTextSize: TextSizes.large,
                ),
                Text (
                  '256 Product  xx', overflow: TextOverflow.ellipsis,
                  style: Theme.of(context). textTheme.labelSmall,
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}