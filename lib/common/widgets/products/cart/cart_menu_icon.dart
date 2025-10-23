
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constents/colors.dart';
//import '../../../../features/shop/screens/cart/cart.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key, required this.onPressed, required this.iconColor,
  });
  final Color iconColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Iconsax .menu_1
      //  IconButton(onPressed:  ()=>Get.to(()=>const CartScreen()), icon:   Icon (Iconsax .notification,color: iconColor,)),
        Positioned(
            right: 0,
            child: Container(width: 18,
              height: 18,
              decoration: BoxDecoration(
                  //color: TColors.black.withOpacity(0.1),
                  color: TColors.black ,
                  borderRadius:  BorderRadius.circular(100)
              ),
              child: Center(child: Text('2',style: Theme.of(context).textTheme.labelLarge!.apply(color:TColors.white, fontSizeFactor: 0.8) ,
              )),
            )
        )
      ],
    );
  }
}


