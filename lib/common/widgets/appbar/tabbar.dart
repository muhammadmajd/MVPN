import 'package:flutter/material.dart';

import '../../../utils/constents/colors.dart';
import '../../../utils/device/device_utality.dart';
import '../../../utils/helper/helper_functions.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  // If you want to add the background color to tabs you have to wrap them in Material widget.
// To do that we need [Preferredsized] Widget and that's why created custom class. [PreferredSizewidget]
  const TTabBar({super.key, required this.tabs});


final List<Widget> tabs;

@override
Widget build(BuildContext context) {
  final dark = THelperFunctions.isDarkMode(context);
  return Material(
    color: dark ? TColors.black : TColors.white,
    child: TabBar(
      tabs: tabs,
      isScrollable: true,
      indicatorColor: TColors.primary,
      labelColor: dark ? TColors.white : TColors.primary,
      unselectedLabelColor: TColors.darkGrey,
    ),
  );
}

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(TDeviceUtils.getappbarheight() );
}
