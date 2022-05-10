import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/attendance.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_schedule_information_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_time_slot_information_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_users_repository.dart';
import 'package:uqu_map_app/repositories/admin_view_lecturer_attendance_repository.dart';
import 'package:uqu_map_app/repositories/admin_view_student_attendance_repository.dart';
import '../repositories/admin_manage_hall_information_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final adminViewLecturerAttendanceViewModel =
StateNotifierProvider<AdminViewLecturerAttendanceViewModel, Map<String, dynamic>>(
        (ref) => AdminViewLecturerAttendanceViewModel(ref));

class AdminViewLecturerAttendanceViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminViewLecturerAttendanceViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminViewLecturerAttendanceRepository _repository = AdminViewLecturerAttendanceRepository();

  final userStateProvider =
  StateProvider<User>((ref) => User());

  final getUsersStateProvider =
  StateProvider<AsyncValue<List<User>>>((ref) => AsyncLoading());

  final getUserAttendanceStateProvider =
  StateProvider<AsyncValue<Attendance>>((ref) => AsyncData(Attendance()));

  getAllUsers(){
    _repository.getAllUsers(
      onSuccess: (users) {
        ref.read(getUsersStateProvider).state = AsyncData(users);
      },
      onFailed: (error) {
        ref.read(getUsersStateProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  getUserAttendance(User user)  {
    ref.read(getUserAttendanceStateProvider).state = AsyncLoading();
    _repository.getUserAttendance(
      user,
      onSuccess: (userAttendance) {
        ref.read(getUserAttendanceStateProvider).state = AsyncData(userAttendance);
      },
      onFailed: (error) {
        ref.read(getUserAttendanceStateProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }


  delete(User user,Attendance attendance,UserAttendance userAttendance) async {
    ref.read(getUserAttendanceStateProvider).state = AsyncLoading();
    _repository.deleteAttendance(
      attendance,
      userAttendance,
      onSuccess: (hall) {
        showSnackBar("attendance deleted", Colors.red);
        getUserAttendance(user);
      },
      onFailed: (error) {
        getUserAttendance(user);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  addAttendance()  {
    _repository.addAttendance();
  }

}
