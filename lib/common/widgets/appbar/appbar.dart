import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


import '../../../utils/constents/colors.dart';
import '../../../utils/constents/sizes.dart';
import '../../../utils/device/device_utality.dart';
import '../../../utils/helper/helper_functions.dart';
import '../drawer/menu_drawer_icon.dart';
class TAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TAppBar({super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow =true,
  
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:0),
    child: AppBar(
      automaticallyImplyLeading: false,
      leading: showBackArrow?IconButton(onPressed: ()=>Get.back(), icon:  Icon(Iconsax.arrow_left,color: dark?Colors.white: Colors.black,))
      :leadingIcon !=null?
      IconButton(onPressed: leadingOnPressed, icon:  Icon(leadingIcon)):TMenuIcon(onPressed: () { Scaffold.of(context).openDrawer(); }, iconColor: TColors.white,),
      title: title,
      actions: actions,
    ),);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getappbarheight());
 // Size get preferredSize => Size.fromHeight(TDeviceUtils.getappbarheight());
}
