import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class LecturerManageHallsRepository extends BaseRepository {

  getAllHalls(
      {required Function(List<Hall> halls) onSuccess,
        required Function(String error) onFailed}) {

    FirebaseFirestore.instance
        .collection(Strings.hallCollection)
        .get()
        .then((value) {
      if ((value.size > 0)) {
        List<Hall> hallList = [];

        for (var element in value.docs) {
          Hall hall = Hall.fromJson(element.data());
          print("Hall Status:  ${hall.status}");

          hallList.add(hall);
        }

        onSuccess(hallList);
      }else{
        onFailed("No building found");
      }
    });
  }


  Future<void> reserve(
      Hall currentHall,
      {required Function(String message) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    DocumentReference collection =
    fireStore.collection(Strings.hallCollection).doc(currentHall.hallId);
    Hall hallTo = Hall();
    hallTo.id = currentHall.hallId;
    hallTo.hallId = currentHall.hallId;
    hallTo.hallName = currentHall.hallName;
    hallTo.capacity = currentHall.capacity;
    hallTo.addByAdminId = currentHall.addByAdminId;
    hallTo.addByAdminUserName = currentHall.addByAdminUserName;
    hallTo.status = "Reserved";
    hallTo.reservedByUserName = (loggedUser != null) ? loggedUser.userName : "null";
    hallTo.reservedByUserId =  (loggedUser != null) ? loggedUser.id : "null";



    collection.set(hallTo.toJson()).then((value) {
      onSuccess("Hall Reserved");
    }).catchError((error) {
      onFailed("Unable to reserve");
      print("Failed to update hall: $error");
    });

  }


  Future<void> cancelReservation(
      Hall currentHall,
      {required Function(String message) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    DocumentReference collection =
    fireStore.collection(Strings.hallCollection).doc(currentHall.hallId);
    Hall hallTo = Hall();
    hallTo.id = currentHall.hallId;
    hallTo.hallId = currentHall.hallId;
    hallTo.hallName = currentHall.hallName;
    hallTo.capacity = currentHall.capacity;
    hallTo.addByAdminId = currentHall.addByAdminId;
    hallTo.addByAdminUserName = currentHall.addByAdminUserName;

    hallTo.status = "Free";
    hallTo.reservedByUserName = null;
    hallTo.reservedByUserId =  null;


    collection.set(hallTo.toJson()).then((value) {
      onSuccess("Hall Reservation Cancelled");
    }).catchError((error) {
      onFailed("Unable to reserve");
      print("Failed to update hall: $error");
    });

  }

}