import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';

class MyProfileRepository extends BaseRepository {
  Future<User?> getLoggedUser() async {
    return await getUser();
  }

  Future<void> updateProfile(
      String firstName, String lastName, String email, String password,
      {required Function(User user) onSuccess,
      required Function(String error) onFailed}) async {
    User? loggedUser = await getLoggedUser();

    DocumentReference collection =
        fireStore.collection(Strings.userCollection).doc(loggedUser!.userName);
    User user = User();
    user.id = loggedUser.id;
    user.role = loggedUser.role;
    user.userName = loggedUser.userName;

    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    user.password = password;

    collection.set(user.toJson()).then((value) {
      sharedPreferencesService.saveToDisk(Strings.userPrefKEY, jsonEncode(user));
      onSuccess(user);
      print("User added");
    }).catchError((error) {
      onFailed("Service Error");
      print("Failed to add User: $error");
    });
  }
}
