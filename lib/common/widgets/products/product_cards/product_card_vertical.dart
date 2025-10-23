
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; 
import './../../../../common/widgets/images/t_roundes_image.dart';
import './../../../../common/widgets/texts/t_brand_title_text_with_verified.dart';
import './../../../../utils/constents/image_strings.dart';

import '../../../../utils/constents/colors.dart';
import '../../../../utils/constents/sizes.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../styles/shadows.dart'; 
import '../../custom_shapes/container/rounded_container.dart';
import '../../icons/t_circular_icon.dart';
import '../../texts/product_price.dart';
import '../../texts/product_title_text.dart';

class TProductCardVertical extends StatelessWidget
{ const TProductCardVertical ({super.key});
@override
Widget build (BuildContext context) {
  final dark = THelperFunctions.isDarkMode (context) ;
// Container with side paddings, color, edges, radius and shadow.
  return GestureDetector(
  //  onTap: ()=> Get.to(()=> const ProductDetail()),
    child: Container( width: 180,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
    boxShadow: [
      TShadowStyle.verticalProductShadow],
        borderRadius: BorderRadius.
        circular (TSizes .productImageRadius),
        color: dark ? TColors.darkerGrey : TColors.white,
    ),
      child: Column(
        children:[
          /// Thumbnail, Wishlist Button, Discount tag
          TRoundedContainer(
            height: 150,
            padding: const EdgeInsets.all(TSizes.sm),
            backgroundColor: dark? TColors.dark :TColors.light,

            child:   Stack(
              children: [
                /// Thumbnail Image
                const TRoundedImage(
                  height:150,

                  imageUrl: TImages.promoBanner2, applyImageRadius: true, fit: BoxFit.cover,),
                /// -- Sale Tag
                Positioned(
                  top: 7,
                  //left: 2,
                  child: TRoundedContainer(
                    radius: TSizes.sm,
                    backgroundColor: TColors.secondary.withOpacity(0.8),
                   child: Text('25%',style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black),),
                  ),
                ),
                /// -- Favourite Icon Button
                const Positioned(
                    top:0,
                    right:0,
                    child:  TCircularIcon(color: Colors.red, icon: Iconsax.heart5,))
              ],
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwItems/2,),
          /// Details
            const Padding(padding: EdgeInsets.only(left: TSizes.sm),
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [

              TProductTitleText(title: 'Green Nike Air Shoes', smallSize: true,),
              SizedBox(height: TSizes.spaceBtwItems/2,),
              TBrandTitleWithVerifiedIcon(title: 'Nike'),

            ],
          ),),
          const Spacer(),
          /// Price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Price
              const Padding(
                padding: EdgeInsets.only(left: TSizes.sm),
                child: TProductPriceText(price:'35.0', isLarge: true),
              ),
              Container (
                decoration: const BoxDecoration(
                  color: TColors. dark, borderRadius: BorderRadius .only (
                  topLeft: Radius .circular (TSizes .cardRadiusMd),
                  bottomRight: Radius.circular (TSizes.productImageRadius),
                ), // BorderRadius.only
                ),
                child: const SizedBox(
                    width: TSizes.iconLg *1.2,
                    height: TSizes.iconLg  * 1.2,
                    child:   Center(child: Icon (Iconsax.add, color: Colors. white,))),
              ), // Container

            ],
          )


        ]
      ),

    ),
  );
  }
}


