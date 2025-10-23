import 'package:flutter/material.dart';


import '../../../utils/constents/colors.dart';
import '../../../utils/constents/sizes.dart';
import '../../../utils/helper/helper_functions.dart';
import '../images/t_circular_image.dart';
class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.onTap,
    this.isNetworkImage = true

  });
  //TImages.deliveredEmailIllustration, 'Shoes category'
  final String image, title;
  final Color textColor ;
  final Color? backgroundColor;
  final bool isNetworkImage;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark =THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: Column(
          children: [
            /*Container(
              width:  56,
              height: 56,
              padding:  const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                  color: backgroundColor?? (dark?TColors.black: TColors.white),
                  borderRadius: BorderRadius.circular(100)
              ),
              child:  Center(

                  child: Image(image: AssetImage(image),
                    fit: BoxFit.cover,
                    color: dark? TColors.light : TColors.dark ,)),

            ),*/
            TCircularImage(
                image: image,
                 fit: BoxFit.fill,
                padding: TSizes.sm * 0.4,
                isNetworkImage: isNetworkImage,
                backgroundColor: backgroundColor,
                overlayColor: THelperFunctions.isDarkMode(context) ? TColors.light : TColors.dark
            ),
            /// Text
            const SizedBox (height: TSizes.spaceBtwItems / 2),
            Expanded(
              child: SizedBox ( width: 65,

                child: Text(title,
                  style: Theme.of(context). textTheme.labelMedium!.apply (color: Colors.white),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            //
          ],
        ),
      ),
    );
  }
}

