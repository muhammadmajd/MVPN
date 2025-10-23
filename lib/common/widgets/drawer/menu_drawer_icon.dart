
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constents/colors.dart';

class TMenuIcon extends StatelessWidget {
  const TMenuIcon({
    super.key, required this.onPressed, required this.iconColor,
  });
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(onPressed:  onPressed, icon:   Icon (Iconsax .menu_1,color: iconColor,)),


      ],
    );
  }
}


