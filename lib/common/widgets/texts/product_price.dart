
import 'package:flutter/material.dart';

class TProductPriceText extends StatelessWidget {
  const TProductPriceText({
    super.key,
    this.currencysign ='\$',
    required this.price,
    this.maxLines =1,
    this.isLarge = false,
    this.lineThrough = false,
  });
  final String currencysign, price;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;
  @override
  Widget build(BuildContext context) {
    return Text (
      currencysign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of (context). textTheme. headlineMedium! .apply (decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of (context). textTheme.titleLarge!.apply (decoration: lineThrough ? TextDecoration. lineThrough : null),
    );
  }
}
