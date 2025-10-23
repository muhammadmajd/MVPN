import 'package:flutter/material.dart';

import '../../../utils/constents/colors.dart';
import '../../../utils/constents/sizes.dart';
import '../../../utils/helper/helper_functions.dart';
class ListTileItem extends StatelessWidget {
  const ListTileItem({
    super.key, required this.name,
    this.onTap, required this.icon,
  });
  final String name;
  final  GestureTapCallback? onTap;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ListTile(
      //  leading: Icon(Icons.home,color:Colors.white),
        title: Center(child: Row(
          children: [
            icon,
            SizedBox(width: TSizes.defaultSpace,),
            Text(name  ,
              style: TextStyle(color: dark?TColors.light: TColors.dark,fontFamily: 'Cairo',fontSize: 16,fontWeight: FontWeight.normal),),

          ],
        )),
        onTap: onTap

    );
  }
}