import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/models/schedule.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class AdminManageScheduleInformationRepository extends BaseRepository{
  final format = DateFormat("dd-MM-yyyy HH:mm");

  void addSchedule(
      String lectureName,
      String lecturerName,
      String startDateTime,
      String endDateTime,
      List<User> lecturers,
      {required Function(Schedule schedule) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();
    String lectureId = Uuid().v5(Uuid.NAMESPACE_URL,lectureName);

    FirebaseFirestore.instance
        .collection(Strings.scheduleCollection)
        .doc(lectureId)
        .get()
        .then((value) async {

      if (value.data() == null) {

        DocumentReference collection =
        fireStore.collection(Strings.scheduleCollection).doc(lectureId);

        Schedule schedule = Schedule();
        schedule.lectureId = lectureId;
        schedule.lectureName = lectureName;
        schedule.startDateTime = startDateTime;
        schedule.endDateTime = endDateTime;
        schedule.id = lectureId;

        for(int i=0;i<lecturers.length;i++){
          if(lecturers.elementAt(i).userName == lecturerName){
            schedule.lecturerName = lecturerName;
            schedule.lecturerId = lecturers.elementAt(i).id;
          }
        }

        schedule.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
        schedule.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";

        bool isValidDate = true;

        getAllSchedule(
          onSuccess: (schedules) {
            for(int i=0; i< schedules.length;i++){
              DateTime initExistingStartDateTime = DateFormat("dd-MM-yyyy HH:mm").parse(schedules[i].startDateTime!);
              print("Existing Start Date: $initExistingStartDateTime");
              DateTime initExistingEndDateTime = DateFormat("dd-MM-yyyy HH:mm").parse(schedules[i].endDateTime!);
              print("Existing End Date: ${initExistingEndDateTime}");
              DateTime newStartDateTime =  DateFormat("dd-MM-yyyy HH:mm").parse(startDateTime);
              print("New Start Date: $newStartDateTime");
              DateTime newEndDateTime =  DateFormat("dd-MM-yyyy HH:mm").parse(endDateTime);
              //print("New End Date: ${newEndDateTime}");

              if (initExistingStartDateTime.isBefore(newStartDateTime) && initExistingEndDateTime.isAfter(newStartDateTime) ) {
                print("newStartDateTime is between existingStartDateTime and newStartDateTime");
                isValidDate = false;
                break;
              } else {
                print("newStartDateTime isn't between existingStartDateTime and newStartDateTime");
              }


            }

            if(isValidDate){
              onFailed("Add Schedule");
              collection.set(schedule.toJson()).then((value) {
                print("schedule Added");
                onSuccess(schedule);
              }).catchError((error) {
                print("Failed to add schedule: $error");
                onFailed("Unable to add schedule");
              });
            }else{
              onFailed("lecture already in this time slot exist");
            }
          },
          onFailed: (error) {
            isValidDate = true;
            if(isValidDate){
              collection.set(schedule.toJson()).then((value) {
                print("schedule Added");
                onSuccess(schedule);
              }).catchError((error) {
                print("Failed to add schedule: $error");
                onFailed("Unable to add schedule");
              });

            }else{
              onFailed("lecture already in this time slot exist");
            }
          },
        );

      } else {
        onFailed("lecture name already exist");
      }

    });

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


  deleteSchedule(
      Schedule schedule,
      {required Function(Schedule schedule) onSuccess,
        required Function(String error) onFailed}) {
    FirebaseFirestore.instance
        .collection(Strings.scheduleCollection)
        .doc(schedule.lectureId).delete().then((value){
      print("Schedule deleted");
      onSuccess(Schedule());
    }).catchError((error) {
      print("Failed to add Schedule: $error");
      onFailed("Unable to delete");
    });
  }

  Future<void> updateSchedule(
      Schedule currentSchedule,
      String lectureName,
      String startDateTime,
      String endDateTime,
      {required Function(Schedule schedule) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    DocumentReference collection =
    fireStore.collection(Strings.scheduleCollection).doc(currentSchedule.lectureId);
    Schedule schedule = Schedule();
    schedule.id = currentSchedule.lectureId;
    schedule.lectureId = currentSchedule.lectureId;
    schedule.lectureName = lectureName;
    schedule.startDateTime = startDateTime;
    schedule.endDateTime = endDateTime;
    schedule.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
    schedule.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";


    collection.set(schedule.toJson()).then((value) {
      onSuccess(schedule);
      print("Schedule update success");
    }).catchError((error) {
      onFailed("Failed to update");
      print("Failed to update schedule: $error");
    });

  }

}