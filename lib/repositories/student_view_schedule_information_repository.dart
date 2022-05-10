import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/models/schedule.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

import '../config/Strings.dart';

class StudentViewSchedulesRepository extends BaseRepository {

  void getSchedule(
      String buildingName,
      String buildingId,
      {required Function(Schedule schedule) onSuccess,
        required Function(String error) onFailed}) async {

  }

  getAllSchedule(
      {required Function(List<Schedule> schedule) onSuccess,
        required Function(String error) onFailed}) {

    FirebaseFirestore.instance
        .collection(Strings.scheduleCollection)
        .get()
        .then((value) {
      if ((value.size > 0)) {
        List<Schedule> scheduleList = [];

        for (var element in value.docs) {
          Schedule schedule = Schedule.fromJson(element.data());
          scheduleList.add(schedule);
        }

        onSuccess(scheduleList);
      }else{
        onFailed("No schedule found");
      }
    });
  }


}