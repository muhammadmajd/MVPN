import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';



import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constents/sizes.dart';
import '../../../../utils/constents/text_strings.dart';
import '../../../../utils/helper/helper_functions.dart';
import 'widgets/signup_form.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
              Text(tr('createAccount'),style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: TSizes.spacesBtwsections,),

              /// Form
              TSignupForm(),
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
