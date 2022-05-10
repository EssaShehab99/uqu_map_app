import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/attendance.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_add_noticeboard_notes_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_scan_qr_attendance_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_view_attendance_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final lecturerViewAttendanceViewModel =
StateNotifierProvider<LecturerViewAttendanceViewModel, Map<String, dynamic>>(
        (ref) => LecturerViewAttendanceViewModel(ref));

class LecturerViewAttendanceViewModel extends BaseViewModel<Map<String, dynamic>> {

  LecturerViewAttendanceViewModel(this.ref,) : super({});
  ProviderReference ref;

  final LecturerViewAttendanceRepository _repository = LecturerViewAttendanceRepository();

  final getUserAttendanceStateProvider =
  StateProvider<AsyncValue<Attendance>>((ref) => AsyncLoading());

  getUserAttendance()  {
  //  ref.read(getUserAttendanceStateProvider).state = AsyncLoading();
    _repository.getUserAttendance(
      onSuccess: (userAttendance) {
        ref.read(getUserAttendanceStateProvider).state = AsyncData(userAttendance);
      },
      onFailed: (error) {
        ref.read(getUserAttendanceStateProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

}