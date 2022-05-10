import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/data/SharedPreferencesService.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/views/StudentScreens/student_home/student_home.dart';
import 'package:uqu_map_app/views/admin_home_view.dart';
import 'package:uqu_map_app/views/home.dart';
import 'package:uqu_map_app/views/lecturer_home_view.dart';
import 'package:uqu_map_app/views/student_home_view.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';
import 'package:uqu_map_app/views/login_screen/login_view.dart';


class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();
    initSplash();
  }

  void initSplash() async{
    await Future.delayed(const Duration(seconds: 2),);
    SharedPreferencesService sharedPreferencesService = Get.find();
    User? user = await getUser(sharedPreferencesService);

    if(user!=null){
      if(user.role == Strings.adminRole){
        Get.offAll(const AdminHomeView());
      }else if(user.role == Strings.lecturerRole){
        Get.offAll(const LecturerHomeView());
      }else if(user.role == Strings.studentRole){
        Get.offAll(const StudentHomeView());
      }else{
        Get.offAll(const Home());
      }
    }else{
      Get.offAll(const Home());
    }

  }

  Future<User?> getUser(SharedPreferencesService sharedPreferencesService)async{
    User? loggedUser;
    String? userJson = await sharedPreferencesService.getFromDisk(Strings.userPrefKEY);

    print('Store dUser: $userJson');

    if (userJson != null) {
      if (userJson != "null") {
        loggedUser = User.fromJson(jsonDecode(userJson));
      } else {
        loggedUser = null;
      }
    } else {
      loggedUser = null;
      //      print('User Not Exist In Preferences');
    }

    return Future.value(loggedUser);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/umaplogo.png")),
          ),

          SizedBox(height: 20,),

          Text("UQU Map Application",style: AppStyles.appHeadingTextStyle())

        ],
      ),
    );
  }


}
