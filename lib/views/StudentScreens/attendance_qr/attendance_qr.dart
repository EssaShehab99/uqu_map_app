import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/data/SharedPreferencesService.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class AttendanceQR extends StatelessWidget {
  const AttendanceQR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Attendance QR",AttendanceQRViewBody());
  }
}

class AttendanceQRViewBody extends StatefulWidget {
  const AttendanceQRViewBody({Key? key}) : super(key: key);

  @override
  _AttendanceQRViewBodyState createState() => _AttendanceQRViewBodyState();
}

class _AttendanceQRViewBodyState extends State<AttendanceQRViewBody> {

  User? appUser = User();


  @override
  void initState() {
    super.initState();
    initGetUser();
  }

  @override
  Widget build(BuildContext context) {
     return Column(
       mainAxisSize: MainAxisSize.max,
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         Text(
           'Scan Qr to mark your attendance',
           style: AppStyles.appSubHeadingTextStyle(
               AppColor.kAccentColorLight, 14, FontWeight.bold),
         ),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: QrImage(
                  data: appUser!.userName.toString(),
                  version: QrVersions.auto,
                  size: 200.0,
                ),
            ),
          ],
        )
      ],
    );
  }

  void initGetUser() async{
    await Future.delayed(const Duration(seconds: 2),);
    SharedPreferencesService sharedPreferencesService = Get.find();
    User? user = await getUser(sharedPreferencesService);

    if(user!=null){
      setState(() {
        appUser = user;
      });
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


}

