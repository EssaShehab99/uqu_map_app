import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_add_noticeboard_notes_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_manage_halls_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_scan_qr_attendance_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_view_attendance_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final lecturerManageHallsViewModel =
StateNotifierProvider<LecturerManageHallsViewModel, Map<String, dynamic>>(
        (ref) => LecturerManageHallsViewModel(ref));

class LecturerManageHallsViewModel extends BaseViewModel<Map<String, dynamic>> {

  LecturerManageHallsViewModel(this.ref,) : super({});
  ProviderReference ref;

  final LecturerManageHallsRepository _repository = LecturerManageHallsRepository();

  final getHallStateProvider =
  StateProvider<AsyncValue<List<Hall>>>((ref) => AsyncLoading());

  getHalls(){
    _repository.getAllHalls(
      onSuccess: (halls) {
        ref.read(getHallStateProvider).state = AsyncData(halls);

      },
      onFailed: (error) {
        ref.read(getHallStateProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  reserveHall(Hall hall){
    _repository.reserve(
      hall,
      onSuccess: (message) {
        showSnackBar(message, Colors.red);
        getHalls();
      },
      onFailed: (error) {
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  cancelReservationHall(Hall hall){
    _repository.cancelReservation(
      hall,
      onSuccess: (message) {
        showSnackBar(message, Colors.red);
        getHalls();
      },
      onFailed: (error) {
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

}