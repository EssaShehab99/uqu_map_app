
import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/schedule.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_manage_schedule_information_repository.dart';
import '../config/Strings.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final adminManageScheduleInformationViewModel =
StateNotifierProvider<AdminManageScheduleInformationViewModel, Map<String, dynamic>>(
        (ref) => AdminManageScheduleInformationViewModel(ref));

class AdminManageScheduleInformationViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminManageScheduleInformationViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminManageScheduleInformationRepository _repository = AdminManageScheduleInformationRepository();

  final lectureNameFieldProvider = StateProvider<String>((ref) => "");
  final updateLectureNameFieldProvider = StateProvider<String>((ref) => "");

  final lecturerNameFieldProvider = StateProvider<String>((ref) => "");
  final updateLecturerNameFieldProvider = StateProvider<String>((ref) => "");
  final lecturersListFieldProvider = StateProvider<List<User>>((ref) => []);

  final startDateTimeFieldProvider = StateProvider<String>((ref) => "");
  final updateStartDateTimeFieldProvider = StateProvider<String>((ref) => "");

  final endDateTimeFieldProvider = StateProvider<String>((ref) =>  "");
  final updateEndDateTimeFieldProvider = StateProvider<String>((ref) => "");


  final getAllLecturerNamesProvider = StateProvider<AsyncValue<List<User>>>((ref) => AsyncLoading());

  final addScheduleStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  final updateScheduleStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));



  final getScheduleStateProvider =
  StateProvider<AsyncValue<List<Schedule>>>((ref) => AsyncLoading());

  getSchedules(){
    _repository.getAllSchedule(
      onSuccess: (buildings) {
        ref.read(getScheduleStateProvider).state = AsyncData(buildings);
        //getBuildings();
      },
      onFailed: (error) {
        ref.read(getScheduleStateProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }



  getAllLecturers(){
    _repository.getAllUsers(
      onSuccess: (users) {
        List<User> lecturerUser = [];

        for(int i=0;i<users.length;i++){
          if(users.elementAt(i).role == Strings.lecturerRole){
           lecturerUser.add(users.elementAt(i));
          }
        }

        ref.read(getAllLecturerNamesProvider).state = AsyncData(lecturerUser);
      },
      onFailed: (error) {
        ref.read(getAllLecturerNamesProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );


  }

  addSchedule(){
    var lectureName = ref.read(lectureNameFieldProvider).state;
    var lecturerName = ref.read(lecturerNameFieldProvider).state;
    var startDateTime = ref.read(startDateTimeFieldProvider).state;
    var endDateTime = ref.read(endDateTimeFieldProvider).state;

    ref.read(addScheduleStateProvider).state = AsyncLoading();



    List<User> users = ref.read(lecturersListFieldProvider).state;

    List<User> lecturerUser = [];

    for(int i=0;i<users.length;i++){
      if(users.elementAt(i).role == Strings.lecturerRole){
        lecturerUser.add(users.elementAt(i));
      }
    }



    if(validateScheduleData()){
      _repository.addSchedule(
        lectureName,
        lecturerName,
        startDateTime,
        endDateTime,
        lecturerUser,
        onSuccess: (schedule) {
          ref.read(addScheduleStateProvider).state = AsyncData(0);
          showSnackBar("Schedule successfully added", Colors.red);
          ref.read(lectureNameFieldProvider).state = '';
          ref.read(startDateTimeFieldProvider).state = '';
          ref.read(endDateTimeFieldProvider).state = '';
          getSchedules();
        },
        onFailed: (error) {
          ref.read(addScheduleStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          getSchedules();
        },
      );
    }else{
      ref.read(addScheduleStateProvider).state = AsyncData(0);
    }

  }

  delete(Schedule schedule) async {
    ref.read(getScheduleStateProvider).state = AsyncLoading();
    _repository.deleteSchedule(
      schedule,
      onSuccess: (user) {
        showSnackBar("Schedule deleted", Colors.red);
        getSchedules();
      },
      onFailed: (error) {
        getSchedules();
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  bool validateScheduleData() {
    var lectureName = ref.read(lectureNameFieldProvider).state;
    var lecturerName = ref.read(lecturerNameFieldProvider).state;
    var startDateTime = ref.read(startDateTimeFieldProvider).state;
    var endDateTime = ref.read(endDateTimeFieldProvider).state;

    if (lectureName.isEmpty) {
      showSnackBar("Error: Please enter lecture name", Colors.red);
      return false;
    } else if (startDateTime.isEmpty) {
      showSnackBar("Error: Please enter startDateTime", Colors.red);
      return false;
    } else if (endDateTime.isEmpty) {
      showSnackBar("Error: Please enter endDateTime", Colors.red);
      return false;
    } else if (lecturerName.isEmpty) {
      showSnackBar("Error: Please select lecturer", Colors.red);
      return false;
    }else {
      return true;
    }
  }

  bool validateUpdateSchedule() {
    var lectureName = ref.read(updateLectureNameFieldProvider).state;
    var startDateTime = ref.read(updateStartDateTimeFieldProvider).state;
    var endDateTime = ref.read(updateEndDateTimeFieldProvider).state;

    if (lectureName.isEmpty) {
      showSnackBar("Error: Please enter lecture name", Colors.red);
      return false;
    } else if (startDateTime.isEmpty) {
      showSnackBar("Error: Please enter startDateTime", Colors.red);
      return false;
    } else if (endDateTime.isEmpty) {
      showSnackBar("Error: Please enter endDateTime", Colors.red);
      return false;
    }else {
      return true;
    }
  }

  updateSchedule(
      Schedule schedule,
      {required Function(bool isScheduleUpdated) isScheduleUpdated}) async {
    ref
        .read(updateScheduleStateProvider)
        .state = const AsyncLoading();

    var lectureName = ref
        .read(updateLectureNameFieldProvider)
        .state;
    var startDateTime = ref
        .read(updateStartDateTimeFieldProvider)
        .state;
    var endDateTime = ref
        .read(updateEndDateTimeFieldProvider)
        .state;

    if (validateUpdateSchedule()) {
      _repository.updateSchedule(
        schedule, lectureName, startDateTime, endDateTime,
        onSuccess: (schedule) {
          showSnackBar("Schedule successfully updated", Colors.red);
          ref
              .read(updateScheduleStateProvider)
              .state = AsyncError(3);
          isScheduleUpdated(true);
          getSchedules();
        },
        onFailed: (error) {
          ref
              .read(updateScheduleStateProvider)
              .state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          isScheduleUpdated(false);
        },
      );
    } else {
      ref
          .read(updateScheduleStateProvider)
          .state = AsyncData(0);
    }
  }

}
