
import 'dart:convert';



import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

import '../../../common/widgets/web_view/web_view_controller.dart';

import '../../../features/authontication/models/user_model_bassel.dart';
import '../../../utils/popups/loaders.dart';

import '../../services/data_global.dart';
import '../../services/user_global.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();


  @override
  void onInit() {
    getUser();
    super.onInit();

  }

   getUser() async {
    try {

     // var data = localStorage.read('user') ?? UserModelBassel.empty();

      final prefs = await SharedPreferences.getInstance();

      String? userJson = prefs.getString('user');

      print('userJson');
      print(userJson);

      if (userJson != null) {
      // Convert JSON string back to User object
        Map<String, dynamic> userMap = jsonDecode(userJson);
        print(userMap);
        UserGlobal.authUser = UserModelBassel.fromJsonShared(userMap);
        print('UserGlobal.authUser11');
        print( UserGlobal.authUser);
        /*
        {"fname":"Bassel","lname":"SM","username":"smandarb","email":"smandarb@gmail.com","mobile":"963944233037","password":"",
        "sex":"1","TOKEN":"11::2::f2ad6072846209e3298c8cd1ff037777","country":"","ActiveAccount":"1","ProfilePicture":""}
         */
        print(UserGlobal.authUser.token);
        print(UserGlobal.authUser.email);
        print(UserGlobal.authUser.firstName);
        print(UserGlobal.authUser.lastName);
        print(UserGlobal.authUser.activeAccount);
      }
      //prefs.setString('activated
        //UserGlobal.authUser = UserModelBassel.fromJson(data);
      print('UserGlobal.authUser.token');
        print(UserGlobal.authUser.token);


    }
    catch(e)
    {
      TLoaders. errorSnackBar(title: 'Oh Snap', message: e.toString());
     // return UserModelBassel.empty();

    }

  }

  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefs.remove('user');

    print('clear-----');
    getUser();
  }
  final localStorage = GetStorage ();
 int timeout=60;

  Future<UserModelBassel> loginWithEmailAndPassword(String email,
      String password) async {
    try {
      print('-----');
      print(password);
      UserModelBassel authUser= UserModelBassel.empty();
      var response = await http.post(Uri.parse(DataGlobal.url), body:
      {'service':'login','email' :email,

        'password' : password.toString(),
        'fbtoken':UserGlobal.fbToken
      }).timeout( Duration(seconds: timeout)).timeout( Duration(seconds: timeout)
      );
      //print(response.body);
      if (response.statusCode == 200)
      {
        print('response.body');
        print(response.body);

        Map data = jsonDecode(response.body);

        if(data['status'].toString()=="true")
        {
          print('response.body');
          print(response.body);
          authUser= UserModelBassel.fromJson(data['info']);
          print('response.body11');
          UserGlobal.authUser = authUser;
          print(authUser);
          saveUser(UserGlobal.authUser);
          print('----ttt------');
          print(UserGlobal.authUser.token);
          print( UserGlobal.authUser.email);

        }

      }

      return authUser;

     // var response = awiat THttpHelper.post(endpoint, data)

    }  catch (e) {
      print(e.toString());
      throw 'Something went wrong. Please try again';
    }
  }
/// Change Password
  Future<UserModelBassel> changePassword(String password,
      String newPassword, String confirmPassword) async {
    try {
      UserModelBassel authUser= UserModelBassel.empty();
      //_password=???&new_password=??&confirm_new_password=??
      var response = await http.post(Uri.parse(DataGlobal.url), body:
      {
        'service':'change_password',
        'email':UserGlobal.authUser.username,
        'token' :UserGlobal.authUser.token,
        'old_password' : password.toString(),
        'new_password' : newPassword.toString(),
        'confirm_new_password' : confirmPassword.toString(),
        'fbtoken':UserGlobal.fbToken
      }).timeout( Duration(seconds: timeout)).timeout( Duration(seconds: timeout)
      );
      if (response.statusCode == 200) {
        print('response.body');
        print(response.body);

        Map data = jsonDecode(response.body);
        UserGlobal.message= data['message'];
        if(data['status'].toString()=='true') {
//11##2##f2ad6072846209e3298c8cd1ff037777
          authUser= UserModelBassel.fromJson(data['info']);
          UserGlobal.authUser = authUser;
          print(authUser);
          saveUser(UserGlobal.authUser);
          print('----------');
          print( UserGlobal.authUser.email);

          Get.offAll(()=>   HomeScreen());

        }

      } else {

      }

      return authUser;

      // var response = awiat THttpHelper.post(endpoint, data)

    }  catch (e) {
      UserGlobal.message='Something went wrong. Please try again';
      throw 'Something went wrong. Please try again';
    }
  }
  Future<bool> signup( String email,String user_name,String fName,String lName,String country,String password,String mobile) async{
    try{
      /*
https://alnashra.org/karna/trial/app/api/services.php?service=register&
email=bassel@e-gate.me&user_name=bassel&fname=bassel&lname=sm&mobile=963944233037&sex=1&country=sy&password=123456
       */
      var response = await http.post(Uri.parse(DataGlobal.url), body:
      {'service':'register','email' : email,
        'user_name' : user_name,
        'fname' : fName,
        'lname':lName,

        'country':country,
        'password':password,
        'mobile':mobile,
        'fbtoken':UserGlobal.fbToken
      }).timeout( Duration(seconds: timeout)).timeout( Duration(seconds: timeout));

      print(response.body);
      if (response.statusCode == 200) {
        //print(response.body);
        Map data = jsonDecode(response.body);

        UserGlobal.message= data['message'];
        if(data['status'].toString()=='true')
        {
          UserGlobal.userName=user_name;
          return true;
        }
        else
        {
          return false;
        }
      }
      if (response.statusCode == 1001)
      {
        //"Please fill requested info correctly"
        //this.result= 'الرجاء ملء المعلومات المطلوبة بشكل صحيح';
        return false;
      }
      else{
        UserGlobal.message= 'حدث خطأ أثناء تسجيل الاستراك الرجاء إعادة التسجي';
        return false;

      }
    }
    catch(e)
    {
      UserGlobal.message=e.toString();
      return false;

    }
  }

  Future<bool> updateProfile( String email,String user_name,String fName,String lName,String country,String mobile) async{
    try{
      print(UserGlobal.authUser.token);
      /*
https://alnashra.org/karna/trial/app/api/services.php?service=register&
email=bassel@e-gate.me&user_name=bassel&fname=bassel&lname=sm&mobile=963944233037&sex=1&country=sy&password=123456
       */
      print('66666666');
      print('user_name');
      print(user_name);
      var response = await http.post(Uri.parse(DataGlobal.url), body:
      {'service':'update_profile',
        'email' : UserGlobal.authUser.username,
        'profile_email':email,
        'user_name' : user_name,
        'fname' : fName,
        'lname':lName,

        'country':country,
        'mobile':mobile,
        'sex':'1',
        'token':UserGlobal.authUser.token
      }).timeout( Duration(seconds: timeout)).timeout( Duration(seconds: timeout));

      print(response.body);
      if (response.statusCode == 200) {
        //print(response.body);
        Map data = jsonDecode(response.body);

        UserGlobal.message= data['message'];
        if(data['status'].toString()=='true')
        {
          UserGlobal.userName=user_name;
          return true;
        }
        else
        {
          return false;
        }
      }
      if (response.statusCode == 1001)
      {
        //"Please fill requested info correctly"
        //this.result= 'الرجاء ملء المعلومات المطلوبة بشكل صحيح';
        return false;
      }
      else{
        UserGlobal.message= 'حدث خطأ أثناء تسجيل الاستراك الرجاء إعادة التسجي';
        return false;

      }
    }
    catch(e)
    {
      UserGlobal.message=e.toString();
      return false;

    }
  }

  Future<UserModelBassel> activate( String userName,String code,String fbtoken) async{

    try{
      // String url1='http://thebestinsyria.net/media/dev/site/services.php?service=login&email=smandarb@gmail.com&password=984088717';
      //  var response = await http.post(url1).timeout( Duration(seconds: timeout)).timeout( Duration(seconds: timeout));

      var response = await http.post(Uri.parse(DataGlobal.url), body:
      {'service':'activate','email' : userName,
        'code' : code,
        'fbtoken':UserGlobal.fbToken
      }).timeout( Duration(seconds: timeout)).timeout( Duration(seconds: timeout));
      if (response.statusCode == 200) {
        print(response.body);
        Map data = jsonDecode(response.body);
        String checkStatus= data['status'].toString();
        print( '--------------------------------$checkStatus');
        if(data['status'].toString()=='true')
        {
          UserGlobal.authUser= UserModelBassel.fromJson(data['info']);
           saveUser(UserGlobal.authUser);
          return  UserGlobal.authUser;

        }

        else
        {
          UserGlobal.message='اسم المستخدم أو كلمة المرور غير صحيحة';
          return  UserGlobal.authUser;
        }
      }
      else
      {
        // addUserToSF('-2','-2','-2');
        return  UserGlobal.authUser;
      }
    }
    catch(e)
    {
      UserGlobal.message=e.toString();
      return  UserGlobal.authUser;

    }
  }



  /// Save user to local storage
  void saveUser(UserModelBassel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('UserName', user.username);
      prefs.setString('Token', user.token);
      prefs.setString('activated', user.activeAccount);
      prefs.setString('email', user.email);
      String userJson = jsonEncode(user.toJson());
      await prefs.setString('user', userJson);

      //localStorage.write('UserName', user.username);
      //localStorage.write('Token', user.token);
    } catch (e)
    {
      print(e.toString());
    }
  }




  void logout() async{
    try {
      print(' UserGlobal.authUser.username');
      print( UserGlobal.authUser.username);
      var response = await http.post(Uri.parse(DataGlobal.url), body:
      {'service':'logout',
        'email' : UserGlobal.authUser.username,
        'token' : UserGlobal.authUser.token,
        'fbtoken':UserGlobal.fbToken


      }).timeout( Duration(seconds: timeout)).timeout( Duration(seconds: timeout));

      print(response.body);
      //{"message":"Sign out success","status":"true","info":""}
      Map data = jsonDecode(response.body);
    //////////////////////
      /*await clearPreferences();
      UserGlobal.authUser= UserModelBassel.empty();
      UserGlobal.authUser.token='';
      final webController =WebController.instance;
      webController.clearWebViewCache();*/
    //  webController.scaffoldKey.currentState?.closeDrawer();
      ///////////////////
      if (response.statusCode == 200) {
        String checkStatus= data['status'].toString();
        UserGlobal.message=data['message'].toString();

        if(checkStatus=='true')
          {
            await clearPreferences();
            UserGlobal.authUser= UserModelBassel.empty();
            UserGlobal.authUser.token='';
            //final webController =WebController.instance;
            //webController.clearWebViewCache();
           // webController.scaffoldKey11.currentState?.closeDrawer();
           // webController.resetController();

            Get.offAll(()=>   HomeScreen());
          } else {
          TLoaders.errorSnackBar (title: 'Oh Snap!', message: UserGlobal.message);
        }


        //Restart.restartApp();

      }

      // localStorage.remove('user');
      //localStorage.remove('user');
     // UserGlobal.authUser = UserModelBassel.empty();


      //Get.offAll(()=>NavigationController());
    }
    catch(e)
    {
     // TLoaders. errorSnackBar(title: 'Oh Snap', message: e.toString());
    }

  }



}