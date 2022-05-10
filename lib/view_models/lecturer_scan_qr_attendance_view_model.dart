import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_scan_qr_attendance_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final lecturerScanQRAttendanceViewModel =
StateNotifierProvider<LecturerScanQRAttendanceViewModel, Map<String, dynamic>>(
        (ref) => LecturerScanQRAttendanceViewModel(ref));

class LecturerScanQRAttendanceViewModel extends BaseViewModel<Map<String, dynamic>> {

  LecturerScanQRAttendanceViewModel(this.ref,) : super({});
  ProviderReference ref;

  final LecturerScanQRAttendanceRepository _repository = LecturerScanQRAttendanceRepository();

  final markAttendanceStateProvider = StateProvider<AsyncValue<int>>((ref) => AsyncData(0));


  markAttendance(){
    ref.read(markAttendanceStateProvider).state = const AsyncLoading();
    try {
      _repository.addAttendance(
        onSuccess: (attendance) {
          ref
              .read(markAttendanceStateProvider)
              .state = const AsyncData(0);
          showSnackBar("Attendance Marked", Colors.blue);
        },
        onFailed: (error) {
          ref
              .read(markAttendanceStateProvider)
              .state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
        },
      );
    }catch(Exception ){
      ref
          .read(markAttendanceStateProvider)
          .state = AsyncError(3);
      showSnackBar("Error: Something wrong", Colors.red);
    }



  }
 /* getBuildings() {
    _repository.getAllBuildings(
      onSuccess: (buildings) {
        ref
            .read(addBuildingStateProvider)
            .state = AsyncData(buildings);
        //getBuildings();
      },
      onFailed: (error) {
        ref
            .read(addBuildingStateProvider)
            .state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }*/
}