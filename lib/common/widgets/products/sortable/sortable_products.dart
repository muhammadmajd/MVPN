import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constents/sizes.dart';
import '../../brand/brand_card.dart';
import '../../layouts/grid_layout.dart';
import '../../texts/section_heading.dart';
import '../product_cards/product_card_vertical.dart';

class TSortableProducts extends StatelessWidget {
  const TSortableProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Dropdown
        DropdownButtonFormField(
          decoration: const InputDecoration (
              prefixIcon: Icon (Iconsax.sort)),
          onChanged: (value){},
          value: 'Name',
          items: ['Name','Higher Price', 'Lower Price','Sale', 'Newest', 'Popularity']
              .map((option) => DropdownMenuItem<String>(
            value: option, // Set the value for each item
            child: Text(option),
          ))
              .toList(),),
        const SizedBox(height: TSizes .spacesBtwsections),
        /// Products
        TGridLayout(itemCount:8, itemBuilder: (_, index) => const TProductCardVertical())
      ],
    );
  }
}
