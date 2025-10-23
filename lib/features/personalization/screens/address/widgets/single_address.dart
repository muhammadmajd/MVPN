import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shapes/container/rounded_container.dart';
import '../../../../../utils/constents/colors.dart';
import '../../../../../utils/constents/sizes.dart';
import '../../../../../utils/helper/helper_functions.dart';
class TSingleAddress extends StatelessWidget {
  const TSingleAddress({super.key,
    required this.selectedAddress});

  final bool selectedAddress;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode (context);
    return  TRoundedContainer(
      width: double.infinity,
      showBorder: true,
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: selectedAddress ? TColors.primary.withOpacity (0.5) : Colors. transparent,
      borderColor: selectedAddress
          ? Colors.transparent: dark
          ? TColors.darkerGrey :TColors.grey,
      margin: const EdgeInsets.only (bottom: TSizes.spaceBtwItems),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
            selectedAddress ? Iconsax.tick_circle5 : null,
            color: selectedAddress
                ? dark
                ? TColors. light :TColors.dark
            :null,),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Egate',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              style: Theme.of(context). textTheme. titleMedium,
              ),
              const SizedBox (height: TSizes.sm / 2),
              const Text (' (+963) 937 273 971', maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox (height: TSizes.sm / 2),
              const Text ('82356 Syria, Damascus', softWrap: true),
            ],
          )

        ],
      ),

    );
  }
}
