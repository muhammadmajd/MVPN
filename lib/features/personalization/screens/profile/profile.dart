import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constents/image_strings.dart';
import '../../../../utils/constents/sizes.dart';
import '../../../../utils/constents/text_strings.dart';
import '../../../../utils/helper/helper_functions.dart';
import '../../../authontication/screens/signup/widgets/signup_form.dart';
import 'widgets/profile_form.dart';
import 'widgets/profile_menu.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: dark?Colors.white : Colors.grey, // Change the back arrow color here
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace,),
          child: Column(
            children: [
              /// title
              Text(tr('updateProfile'),style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: TSizes.spacesBtwsections,),

              /// Form
              TProfileForm(),
              const SizedBox(height: TSizes.spacesBtwsections,),
              /// Divider
              //const TFormDivier(dividerText: TTexts.orSignUpwith),
              const SizedBox(height: TSizes.spacesBtwsections,),
              // const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
