import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class AdminManageUsersRepository extends BaseRepository {
  void addUser(String firstName, String lastName, String email, String userName,
      String role, String password,
      {required Function(User user) onSuccess,
      required Function(String error) onFailed}) async {
    User? loggedUser = await getUser();

    FirebaseFirestore.instance
        .collection(Strings.userCollection)
        .doc(userName)
        .get()
        .then((value) async {
      if (value.data() == null) {
        DocumentReference collection =
            fireStore.collection("users").doc(userName);
        User user = User();
        user.id = Uuid().v5(Uuid.NAMESPACE_URL, userName);
        user.firstName = firstName;
        user.lastName = lastName;
        user.userName = userName;
        user.password = password;
        user.role = role;
        user.email = email;
        user.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
        user.addByAdminUserName =
            (loggedUser != null) ? loggedUser.userName : "null";

        collection.set(user.toJson()).then((value) {
          print("User Added");
          onSuccess(user);
        }).catchError((error) {
          print("Failed to add User: $error");
          onFailed("Unable to add user");
        });
      } else {
        onFailed("User name already exist");
      }
    });

    /* */
  }

  getAllUsers(
      {required Function(List<User> user) onSuccess,
      required Function(String error) onFailed}) {
    FirebaseFirestore.instance
        .collection(Strings.userCollection)
        .get()
        .then((value) {
      if ((value.size > 0)) {
        List<User> usersList = [];

        value.docs.forEach((element) {
          User user = User.fromJson(element.data());
          if(user.role != Strings.adminRole){
            usersList.add(user);
          }
        });
        onSuccess(usersList);
      }else{
        onFailed("No users found");
      }
    });
  }

  deleteUser(
      User user,
      {required Function(User user) onSuccess,
        required Function(String error) onFailed}) {
    FirebaseFirestore.instance
        .collection(Strings.userCollection)
    .doc(user.userName).delete().then((value){
      print("User deleted");
      onSuccess(User());
    }).catchError((error) {
      print("Failed to add User: $error");
      onFailed("Unable to delete");
    });

  }

  Future<void> updateUser(
      User selectedUser,
      String firstName, String lastName, String email, String password,
      {required Function(User user) onSuccess,
        required Function(String error) onFailed}) async {

    DocumentReference collection =
    fireStore.collection(Strings.userCollection).doc(selectedUser.userName);
    User user = User();
    user.id = selectedUser.id;
    user.role = selectedUser.role;
    user.userName = selectedUser.userName;
    user.addByAdminUserName = selectedUser.addByAdminUserName;
    user.addByAdminId = selectedUser.addByAdminId;

    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    user.password = password;

    collection.set(user.toJson()).then((value) {
      onSuccess(user);
      print("User update success");
    }).catchError((error) {
      onFailed("Failed to ");
      print("Failed to update User: $error");
    });
  }

}
