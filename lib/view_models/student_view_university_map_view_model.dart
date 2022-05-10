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
import 'package:uqu_map_app/repositories/student_view_schedule_information_repository.dart';
import 'package:uqu_map_app/repositories/student_view_university_map_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final studentViewUniversityViewModel =
StateNotifierProvider<StudentViewUniversityViewModel, Map<String, dynamic>>(
        (ref) => StudentViewUniversityViewModel(ref));

class StudentViewUniversityViewModel extends BaseViewModel<Map<String, dynamic>> {

  StudentViewUniversityViewModel(this.ref,) : super({});
  ProviderReference ref;

  final StudentViewUniversityMapRepository _repository = StudentViewUniversityMapRepository();

  final getBuildingsStateProvider =
  StateProvider<AsyncValue<List<Building>>>((ref) => AsyncLoading());

  getBuildings(){
    _repository.getAllBuildings(
      onSuccess: (buildings) {
        ref.read(getBuildingsStateProvider).state = AsyncData(buildings);
        //getBuildings();
      },
      onFailed: (error) {
        ref.read(getBuildingsStateProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }


}