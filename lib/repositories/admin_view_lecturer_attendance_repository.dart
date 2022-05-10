import 'package:uqu_map_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_date/random_date.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/attendance.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class AdminViewLecturerAttendanceRepository extends BaseRepository {

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
          if (user.role == Strings.lecturerRole) {
            usersList.add(user);
          }
        });
        onSuccess(usersList);
      } else {
        onFailed("No lecture attendance found");
      }
    });
  }

  getUserAttendance(User user,
      {required Function(Attendance userAttendance) onSuccess,
        required Function(String error) onFailed}) {
    FirebaseFirestore.instance
        .collection(Strings.attendanceCollection)
        .doc(user.id)
        .get()
        .then((value) {
      if (value.data() != null) {
        Attendance attendance = Attendance.fromJson(value.data()!);
        onSuccess(attendance);
      } else {
        onFailed("No lecture attendance found");
      }
    });
  }

  void addAttendance() async {
    UserAttendance userAttendance = UserAttendance();
    userAttendance.dateTime = DateTime.now().toString();
    userAttendance.checkInStatus = "true";

    List<UserAttendance> attendanceList = [];
    attendanceList.add(userAttendance);
    userAttendance.dateTime = RandomDate.withStartYear(2022).toString();
    attendanceList.add(userAttendance);
    userAttendance.dateTime = RandomDate.withStartYear(2022).toString();
    attendanceList.add(userAttendance);
    userAttendance.dateTime = RandomDate.withStartYear(2022).toString();
    attendanceList.add(userAttendance);
    userAttendance.dateTime = DateTime.now().toString();
    attendanceList.add(userAttendance);
    userAttendance.dateTime = DateTime.now().toString();
    attendanceList.add(userAttendance);
    userAttendance.dateTime = DateTime.now().toString();
    attendanceList.add(userAttendance);
    userAttendance.dateTime = DateTime.now().toString();
    attendanceList.add(userAttendance);
    userAttendance.dateTime = DateTime.now().toString();
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

  deleteAttendance(Attendance attendance,UserAttendance userAttendance,
      {required Function(Attendance attendance) onSuccess,
        required Function(String error) onFailed}) {


    attendance.userAttendance!.removeWhere((item) => item.dateTime == userAttendance.dateTime);

    DocumentReference collection =
    fireStore.collection(Strings.attendanceCollection).doc(attendance.studentId);

    collection.set(attendance.toJson()).then((value) {
      print("Attendance Deleted");
      onSuccess(Attendance());
    }).catchError((error) {
      print("unable to delete: $error");
      onFailed('Unable to detete');
    });
  }

}
