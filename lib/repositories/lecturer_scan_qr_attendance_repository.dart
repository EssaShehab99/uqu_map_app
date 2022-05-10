import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/attendance.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class LecturerScanQRAttendanceRepository extends BaseRepository {

  void addAttendance({
        required Function(Attendance attendance) onSuccess,
        required Function(String error) onFailed
      }) async {

    User? user = await getUser();

    FirebaseFirestore.instance
        .collection(Strings.attendanceCollection)
        .doc(user?.id)
        .get()
        .then((value) {
      if (value.data() != null) {
        print("Update Attendance field");
        Attendance attendance = Attendance.fromJson(value.data()!);
        UserAttendance userAttendance = UserAttendance();
        userAttendance.dateTime = DateTime.now().toString();
        userAttendance.checkInStatus = "true";
        attendance.userAttendance?.add(userAttendance);

        DocumentReference collection =
        fireStore.collection(Strings.attendanceCollection).doc(attendance.studentId);

        collection.set(attendance.toJson()).then((value) {
          print("Attendance Added Update");
          onSuccess(attendance);
        }).catchError((error) {
          print("Failed to add Attendance: $error");
          onFailed("Failed to mark");
        });

        onSuccess(attendance);
      } else {
        UserAttendance userAttendance = UserAttendance();
        userAttendance.dateTime = DateTime.now().toString();
        userAttendance.checkInStatus = "true";

        List<UserAttendance> attendanceList = [];
        attendanceList.add(userAttendance);
        Attendance at1 = Attendance();
        at1.id = const Uuid().v4();
        at1.studentId = user?.id;
        at1.userAttendance = attendanceList;

        DocumentReference collection =
        fireStore.collection(Strings.attendanceCollection).doc(at1.studentId);
        collection.set(at1.toJson()).then((value) {
          print("Attendance Added New");
          onSuccess(at1);
        }).catchError((error) {
          print("Failed to add Attendance: $error");
          onFailed("Unable to mark attendance");
        });
      }
    });

  }

  void markAttendance() async {
    UserAttendance userAttendance = UserAttendance();
    userAttendance.dateTime = DateTime.now().toString();
    userAttendance.checkInStatus = "true";

    List<UserAttendance> attendanceList = [];
    attendanceList.add(userAttendance);
    Attendance at1 = Attendance();
    at1.id = const Uuid().v4();
    at1.studentId = "cd736558-bc50-5e7f-a2ce-297e9d7b1465";
    at1.userAttendance = attendanceList;

    DocumentReference collection =
    fireStore.collection(Strings.attendanceCollection).doc(at1.studentId);

    collection.set(at1.toJson()).then((value) {
      print("Attendance Added");
    }).catchError((error) {
      print("Failed to add Attendance: $error");
    });
  }

}