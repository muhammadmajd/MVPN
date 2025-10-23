
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constents/colors.dart';
import '../../../../utils/constents/sizes.dart';
import '../../../../utils/device/device_utality.dart';
import '../../../../utils/helper/helper_functions.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key, required this.text,
    this.icon= Iconsax.search_normal,
    this.showBackground =true,
    this.showBorder =true,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.spacesBtwsections),
    this.onTap,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark= THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding ,
        child: Container(
     //padding: EdgeInsets.only(left: TSizes.defaultSpace,top: TSizes.defaultSpace),
          width: TDeviceUtils.getScreenWidth(context) ,
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
              color: showBackground? dark? TColors.dark :TColors.light: Colors.transparent,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              border:showBorder? Border.all(color: TColors.grey): null
          ),
          child: Row(
            children: [
              Icon(icon, color:  TColors.darkerGrey,),
              const SizedBox(width: TSizes.spaceBtwItems,),
              //Iconsax.search_normal , 'Search in Store',
              Text(text, style: Theme.of(context).textTheme.bodySmall,)
            ],
          ),
      
        ),
      ),
    );
  }
}
