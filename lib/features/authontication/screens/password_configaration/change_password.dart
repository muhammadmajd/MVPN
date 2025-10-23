import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../../../common/styles/spacing_styles.dart';
import '../../../../utils/helper/helper_functions.dart';
import 'widgets/change_password_form.dart';
import 'widgets/change_password_header.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()=>Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub_Title
              TChangePasswordHeader(dark: dark),
              ///form
              const TChangePasswordForm(),

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



