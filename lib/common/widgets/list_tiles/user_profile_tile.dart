
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constents/colors.dart';
import '../../../utils/constents/image_strings.dart';
import '../images/t_circular_image.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
      this.name = 'Coding with T',
      this.email = 'eng.muhammadaliiah@gmail.com' ,
    required this.onPressed,
  });

  final String name;
  final String email;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
   // final controller = UserController.instance;
    return ListTile(
      leading: const TCircularImage(image:
      TImages.user,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text('Muhammad'
          //controller.user.value.fullName
          , style: Theme.of (context).textTheme. headlineSmall!.apply (color: Colors .white)),
      subtitle: Text(
          'eng.muhammadaliah@gmail.com',
          style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors .white)),
      trailing: IconButton(onPressed: onPressed, icon: const Icon (Iconsax.edit, color: TColors.white)),
    );
  }
}
