import 'package:flutter/material.dart';

import '../../../../utils/constents/colors.dart';

class TCircularContainer extends StatelessWidget {
  const TCircularContainer({
    super.key,
    this.child,
    this.width =400,
    this.height =400,
    this.radius =400,
    this.padding =0,
    this.backgroundColor= TColors.white,
    this.margin,
  });
  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Color backgroundColor;


  @override
  Widget build(BuildContext context) {
    return Container(
      //color: TColors.primary,
      padding: const EdgeInsets.all(0),
      child: Container(
        width: width,
        height: height,
        margin:    margin,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgroundColor,
        ),
        child: child,
      ),
    );
  }
}
