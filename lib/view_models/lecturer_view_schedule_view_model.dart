import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/schedule.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_add_noticeboard_notes_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_manage_halls_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_scan_qr_attendance_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_view_attendance_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_view_halls_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_view_schedule_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final lecturerViewScheduleViewModel =
StateNotifierProvider<LecturerViewScheduleViewModel, Map<String, dynamic>>(
        (ref) => LecturerViewScheduleViewModel(ref));

class LecturerViewScheduleViewModel extends BaseViewModel<Map<String, dynamic>> {

  LecturerViewScheduleViewModel(this.ref,) : super({});
  ProviderReference ref;

  final LecturerViewSchedulesRepository _repository = LecturerViewSchedulesRepository();

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

}