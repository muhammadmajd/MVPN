

import 'package:get/get.dart';

import '../controllers/location_controller.dart';
import '../data/repositories/user/user_repository.dart';
import '../features/authontication/controllers/login/login_controller.dart';
import '../utils/check_internet/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    final controller=Get.put(UserRepository());
    controller.getUser();
    Get.put(LoginController());
     Get.put(NetworkManager ()) ;
    final locationController = Get.put(LocationController());
    locationController.getVpnData();
    //locationController.getVpnData();
    //Get.put(NotificationController());


    }
}