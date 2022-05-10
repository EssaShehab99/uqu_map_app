import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class AdminManageBuildingsInformationRepository extends BaseRepository {

  void addBuilding(
      String buildingName,
      String buildingId,
      {required Function(Building building) onSuccess,
       required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    FirebaseFirestore.instance
        .collection(Strings.buildingCollection)
        .doc(buildingId)
        .get()
        .then((value) async {

       if (value.data() == null) {

        DocumentReference collection =
        fireStore.collection(Strings.buildingCollection).doc(buildingId);

        Building building = Building();
        building.id = Uuid().v5(Uuid.NAMESPACE_URL, buildingName);
        building.buildingId = buildingId;
        building.buildingName = buildingName;

        building.lat = "21.65185965740682";
        building.lang = "39.71572493145481";

        building.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
        building.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";

        collection.set(building.toJson()).then((value) {
          print("building Added");
          onSuccess(building);
        }).catchError((error) {
          print("Failed to add building: $error");
          onFailed("Unable to add building");
        });
      } else {
        onFailed("building id already exist");
      }
    });

  }

  getAllBuildings(
      {required Function(List<Building> building) onSuccess,
        required Function(String error) onFailed}) {

    FirebaseFirestore.instance
        .collection(Strings.buildingCollection)
        .get()
        .then((value) {
      if ((value.size > 0)) {
        List<Building> buildingList = [];

        for (var element in value.docs) {
          Building building = Building.fromJson(element.data());
          buildingList.add(building);
        }

        onSuccess(buildingList);
      }else{
        onFailed("No building found");
      }
    });
  }

  deleteBuilding(
      Building building,
      {required Function(User user) onSuccess,
        required Function(String error) onFailed}) {
    FirebaseFirestore.instance
        .collection(Strings.buildingCollection)
        .doc(building.buildingId).delete().then((value){
      print("Building deleted");
      onSuccess(User());
    }).catchError((error) {
      print("Failed to add Building: $error");
      onFailed("Unable to delete");
    });
  }

  Future<void> updateBuilding(
      Building currentBuilding,
      String buildingName,
      String buildingId,
      {required Function(Building building) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    DocumentReference collection =
    fireStore.collection(Strings.buildingCollection).doc(currentBuilding.buildingId);
    Building building = Building();
    building.buildingId = buildingId;
    building.buildingName = buildingName;
    building.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
    building.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";

    collection.set(building.toJson()).then((value) {
      onSuccess(building);
      print("Building update success");
    }).catchError((error) {
      onFailed("Failed to update");
      print("Failed to update building: $error");
    });

  }

}
