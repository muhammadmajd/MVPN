import 'package:flutter/material.dart';



import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constents/text_strings.dart';
import '../../../../utils/helper/helper_functions.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub_Title
              TLoginHeader(dark: dark),
            ///form
            const TLoginForm(),

              /// Divider
              // const TFormDivier(dividerText: TTexts.orSignInwith),
              ///  Footer

             // const  TSocialButtons(),



            ],
          ),

        ),
      ),
    );
  }
}



