import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutMVPNDialog extends StatelessWidget {


  const AboutMVPNDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('MVPN'),
      content: Text(tr('mvpnDevelopedBy')),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            textStyle: TextStyle(color: Colors.green),
            child: Text('ok'),
            onPressed: () {
              Get.back();
            }),
      ],
    );
  }
}
