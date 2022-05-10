import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';

class StudentViewUniversityMapRepository extends BaseRepository{
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
}