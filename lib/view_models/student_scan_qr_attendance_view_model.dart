import 'package:flutter/material.dart';
import 'package:uqu_map_app/repositories/lecturer_scan_qr_attendance_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentScanQRAttendanceViewModel =
StateNotifierProvider<StudentScanQRAttendanceViewModel, Map<String, dynamic>>(
        (ref) => StudentScanQRAttendanceViewModel(ref));

class StudentScanQRAttendanceViewModel extends BaseViewModel<Map<String, dynamic>> {

  StudentScanQRAttendanceViewModel(this.ref,) : super({});
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


}