import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/container/rounded_container.dart';

import '../../../../utils/constents/colors.dart';
import '../../../../utils/constents/image_strings.dart';
import '../../../../utils/constents/sizes.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../icons/t_circular_icon.dart';
import '../../images/t_roundes_image.dart';
import '../../texts/product_price.dart';
import '../../texts/product_title_text.dart';
import '../../texts/t_brand_title_text_with_verified.dart';
class TProductCardHorizontal extends StatelessWidget {
  const TProductCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode (context) ;
    return Container(
        width: 310,
      padding: const EdgeInsets.all(1),
    decoration: BoxDecoration (
    //boxShadow:[TShadowStyle.verticalProductShadow],
    borderRadius: BorderRadius. circular (TSizes.productImageRadius),
    color: dark ? TColors.darkerGrey : TColors.white,
    ),
        child: Row(
          children: [
            /// Thumbnail, Wishlist Button, Discount Tag
            TRoundedContainer(
              height: 120,
              padding: const EdgeInsets.all (TSizes. sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  /// - - Thumbnail Image
                  const SizedBox(
                      height:120,
                      width: 120,
                      child: TRoundedImage (imageUrl: TImages.promoBanner1, applyImageRadius: true,
                      )),

              /// - - sale Tag
              Positioned(
                top: 12,
                  child: TRoundedContainer ( radius: TSizes.sm,
                  backgroundColor: TColors.secondary .withOpacity (0.8),
                  padding: const EdgeInsets. symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                    child: Text('25%', style: Theme.of (context). textTheme. labelLarge! .apply (color: Colors.black)),
                  ),
              ),

            /// - - Favourite Icon Button c
            const Positioned (
                  top: 0,
                   right: 0,
                   child: TCircularIcon(icon: Iconsax.heart5, color: Colors.red),
            ),
                ],
              ),
            ),
            /// Details
            SizedBox(
              width: 172,
              child: Column(
                children: [
                  const Column(
                    // padding: EdgeInsets.only(top: TSizes.sm),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TProductTitleText(title: 'Green Nike Half Sleeves Shirt', smallSize: true),
                      SizedBox (height: TSizes.spaceBtwItems / 2),
                      SizedBox(
                          width: 60,
                          child: TBrandTitleWithVerifiedIcon(title: 'Nike')),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Pricing
                      const Flexible(child: TProductPriceText (price: '256.0 -25555.6')),

                      Container(
                          decoration: const BoxDecoration(
                            color: TColors.dark, borderRadius: BorderRadius.only (
                            topLeft: Radius.circular (TSizes.cardRadiusMd),
                            bottomRight: Radius.circular (TSizes.productImageRadius),
                          ), // BorderRadius. onLy
                          ),
                          child: const SizedBox (
                              width: TSizes.iconLg * 1.2,
                              height: TSizes.iconLg * 1.2,
                              child: Center (child: Icon(Iconsax.add, color: TColors .white)),
                               ),

                      )
                    ],
                  )
                ],
              ),
            )

          ],
        ),
    );
  }
}
