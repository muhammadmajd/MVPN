import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/location_controller.dart';
import '../helpers/ad_helper.dart';
import '../helpers/pref.dart';
import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final _controller = Get.put(LocationController());

    //final fastestVpn = _controller.getAutoOptimalServer();
    final _homeController = Get.put(HomeController());
   /* if(allow_assign)
    {_homeController.vpn.value =  Pref.vpn;}*/

    //  final fastestVpn = _controller.getAutoOptimalServer();
    Future.delayed(Duration(milliseconds: 1500), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      AdHelper.precacheInterstitialAd();
      AdHelper.precacheNativeAd();

      //navigate to home
      Get.off(() => HomeScreen());
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          //app logo
          Positioned(
              left: mq.width * .3,
              top: mq.height * .2,
              width: mq.width * .4,
              child: Image.asset('assets/images/logo.png')),

          //label
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                'MADE BY AIMTechno ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).lightText, letterSpacing: 1),
              ))
        ],
      ),
    );
  }
}
