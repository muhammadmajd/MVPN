import 'package:flutter/material.dart';

import '../../../utils/constents/colors.dart';
import '../../../utils/constents/sizes.dart';
import '../../../utils/helper/helper_functions.dart';
import '../custom_shapes/container/rounded_container.dart';
import 'brand_card.dart';

class TBrandShowcase extends StatelessWidget {
  const TBrandShowcase({
    super.key, required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
        showBorder: true,
        borderColor: TColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        child: Column(children: [

          /// Brand with Products Count
          TBrandCard(showBorder: false, onTap: (){},),
          // const TBrandCardd(showBorder: true)
         const SizedBox(height: TSizes.spaceBtwItems,),
          /// Brand Top 3 Product Images
          Row(
              children: images.map((image) =>
                  brandTopProductImageWidget(image, context)).toList()
          )
        ])
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
      child: TRoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.only (right: TSizes.sm),
        backgroundColor: THelperFunctions.isDarkMode(context) ? TColors
            .darkerGrey : TColors.light,
        child: Image(
            fit: BoxFit.contain, image: AssetImage(image)),
      ), // TRoundedContainer
    );
//
  }
}
