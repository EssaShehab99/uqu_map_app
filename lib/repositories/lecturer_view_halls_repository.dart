import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class LecturerViewHallsRepository extends BaseRepository {

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

}