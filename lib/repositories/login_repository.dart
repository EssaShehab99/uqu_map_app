import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uuid/uuid.dart';

import '../config/Strings.dart';
import 'base_respository.dart';

class LoginRepository extends BaseRepository {
  Future<User?> checkLoginStatus() async {
    return await getUser();
  }

  void login(String userName, String password,
      {required Function(User user) onSuccess,
      required Function(String error) onFailed}) {

    print('email' + ':  ${userName}');
    print('password' + ':  ${password}');

    FirebaseFirestore.instance
        .collection(Strings.userCollection)
        .doc(userName)
        .get()
        .then((value) async {
          
          if(value.data() != null){
           // print('Length User exist');
            User user = User.fromJson(value.data()!);
            if (user.userName == userName && user.password == password) {
            //  user.id = "";
              sharedPreferencesService.saveToDisk(Strings.userPrefKEY, jsonEncode(user));
              onSuccess(user);
            } else {
              onFailed('Unable to verify, Please try again');
            }
          }else{
            // print('Length User not exist');
            onFailed('Unable to verify, Please try again');// user not exist
          }
    });

    //working code below
    /*bool isValidUser = false;
    FirebaseFirestore.instance
        .collection(Strings.userCollection)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        User user = User.fromJson(element.data());
//            print('Collection: ${user.userName}');

        if (user.userName == userName && user.password == password) {
          isValidUser = true;
          onSuccess(user);
        } else {
          isValidUser = false;
        }
      });

      if (isValidUser == false) {
        onFailed("Unable to verify");
      }

    });*/

  }


  void addUser() {
    //print('Add User Called');
/*    CollectionReference collection = fireStore.collection("users");
    User user = User();
    user.id = Uuid().v5(Uuid.NAMESPACE_URL, 'Admin');
    user.userName = "Admin";
    user.password = "Admin";
    user.role = "Admin";

    collection.add(user.toJson())
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add User: $error"));*/

    addAdmin();
    addLecturer();
    addStudent();

  }

  void addStudent() {
       DocumentReference collection = fireStore.collection(Strings.userCollection).doc("Wanting");
    User user = User();
    user.id = Uuid().v5(Uuid.NAMESPACE_URL, 'Wanting');
    user.firstName = 'Wanting';
    user.lastName = 'Emma';
    user.userName = 'Wanting';
    user.password = 'wanting123';
    user.role = Strings.studentRole;
    user.email = 'Wanting@gmail.com';

    collection
        .set(user.toJson())
        .then((value) => print("Student added"))
        .catchError((error) => print("Failed to add Student: $error"));
  }

  void addLecturer() {
    DocumentReference collection = fireStore.collection(Strings.userCollection).doc("Alice");
    User user = User();
    user.id = Uuid().v5(Uuid.NAMESPACE_URL, 'Alice');
    user.firstName = 'Alice';
    user.lastName = 'Wanting';
    user.userName = 'Alice';
    user.password = 'alice123';
    user.role = Strings.lecturerRole;
    user.email = 'Alice@gmail.com';

    collection
        .set(user.toJson())
        .then((value) => print("Lecturer added"))
        .catchError((error) => print("Failed to add Lecturer: $error"));
  }

  void addAdmin() {
    DocumentReference collection = fireStore.collection("users").doc("Admin");
    User user = User();
    user.id = Uuid().v5(Uuid.NAMESPACE_URL, 'Admin');
    user.firstName = 'John';
    user.lastName = 'Doe';
    user.userName = 'Admin';
    user.password = 'Admin';
    user.role = 'Admin';
    user.email = '';

    collection
        .set(user.toJson())
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add User: $error"));
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }
}
