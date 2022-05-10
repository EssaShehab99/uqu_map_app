import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/attendance.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class StudentViewAttendanceRepository extends BaseRepository {

  getUserAttendance(
      {required Function(Attendance userAttendance) onSuccess,
        required Function(String error) onFailed}) async {

    User? user = await getUser();

    FirebaseFirestore.instance
        .collection(Strings.attendanceCollection)
        .doc(user?.id)
        .get()
        .then((value) {
      if (value.data() != null) {
        Attendance attendance = Attendance.fromJson(value.data()!);
        onSuccess(attendance);
      } else {
        onFailed("No student attendance found");
      }
    });
  }

}