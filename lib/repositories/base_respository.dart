import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/data/SharedPreferencesService.dart';
import 'package:uqu_map_app/models/user.dart';

class BaseRepository {
  SharedPreferencesService sharedPreferencesService = Get.find();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<User?> getUser()async{
    User? loggedUser;
    dynamic userJson = await sharedPreferencesService.getFromDisk(Strings.userPrefKEY);

    if (userJson != null) {
      if (userJson != "null") {
        print("User: ${userJson}");
        loggedUser = User.fromJson(jsonDecode(userJson));
        // sharedPreferencesService.saveToDisk("USER","null");
      } else {
        loggedUser = null;
      }
    } else {
      loggedUser = null;
      //      print('User Not Exist In Preferences');
    }

    return Future.value(loggedUser);
  }

  setUpDefault(){

  }
}