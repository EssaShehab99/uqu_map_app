import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class AdminManageHallInformationRepository extends BaseRepository {

  void addHall(
      String hallName,
      String hallId,
      String hallCapacity,
      String freeSeats,
      String hallStatus,
      {required Function(Hall hall) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();



    FirebaseFirestore.instance
        .collection(Strings.hallCollection)
        .doc(hallId)
        .get()
        .then((value) async {

      if (value.data() == null) {

        DocumentReference collection =
        fireStore.collection(Strings.hallCollection).doc(hallId);

        Hall hall = Hall();
        hall.id = Uuid().v5(Uuid.NAMESPACE_URL, hallName);
        hall.hallId = hallId;
        hall.hallName = hallName;
        hall.capacity = hallCapacity;
        hall.freeSeats = freeSeats;
        hall.status = hallStatus;
        hall.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
        hall.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";

     //   print('Hall capacity ads: ${hallStatus}');

        collection.set(hall.toJson()).then((value) {
          print("hall Added");
          onSuccess(hall);
        }).catchError((error) {
          print("Failed to add hall: $error");
          onFailed("Unable to add hall");
        });
      } else {
        onFailed("hall id already exist");
      }
    });

  }

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
        onFailed("No Hall found");
      }
    });
  }

  deleteHall(
      Hall hall,
      {required Function(Hall hall) onSuccess,
        required Function(String error) onFailed}) {
    FirebaseFirestore.instance
        .collection(Strings.hallCollection)
        .doc(hall.hallId).delete().then((value){
      print("Hall deleted");
      onSuccess(Hall());
    }).catchError((error) {
      print("Failed to add Hall: $error");
      onFailed("Unable to delete");
    });
  }

  Future<void> updateBuilding(
      Hall currentHall,
      String hallName,
      String hallId,
      String hallCapacity,
      String freeSeats,
      String hallStatus,
      {required Function(Hall hall) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    DocumentReference collection =
    fireStore.collection(Strings.hallCollection).doc(currentHall.hallId);
    Hall hallTo = Hall();
    hallTo.id = currentHall.hallId;
    hallTo.hallId = hallId;
    hallTo.hallName = hallName;
    hallTo.capacity = hallCapacity;
    hallTo.freeSeats = freeSeats;
    hallTo.status = hallStatus;
    hallTo.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
    hallTo.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";

    collection.set(hallTo.toJson()).then((value) {
      onSuccess(hallTo);
      print("Hall update success");
    }).catchError((error) {
      onFailed("Failed to hall");
      print("Failed to update hall: $error");
    });

  }

}