import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/models/user.dart';
import '../repositories/admin_manage_hall_information_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


final adminManageHallInformationViewModel =
StateNotifierProvider<AdminManageHallInformationViewModel, Map<String, dynamic>>(
        (ref) => AdminManageHallInformationViewModel(ref));

class AdminManageHallInformationViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminManageHallInformationViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminManageHallInformationRepository _repository = AdminManageHallInformationRepository();

  final userStateProvider =
  StateProvider<User>((ref) => User());

  final hallNameFieldProvider = StateProvider<String>((ref) => "");
  final updateHallNameFieldProvider = StateProvider<String>((ref) => "");

  final hallIdFieldProvider = StateProvider<String>((ref) => "");
  final updateHallIdFieldProvider = StateProvider<String>((ref) => "");

  final hallCapacityFieldProvider = StateProvider<String>((ref) => "");
  final updateCapacityFieldProvider = StateProvider<String>((ref) => "");

  final hallFreeSeatsFieldProvider = StateProvider<String>((ref) => "");
  final updateFreeSeatsFieldProvider = StateProvider<String>((ref) => "");

  final hallReservationStatusFieldProvider = StateProvider<String>((ref) => "");
  final updateHallReservationStatusFieldProvider = StateProvider<String>((ref) => "");


  final addHallStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  final updateHallStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

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

  addHall(){
    var hallName = ref.read(hallNameFieldProvider).state;
    var hallId = ref.read(hallIdFieldProvider).state;
    var hallCapacity = ref.read(hallCapacityFieldProvider).state;
    var hallFreeSeats = ref.read(hallFreeSeatsFieldProvider).state;
    var hallStatus = ref.read(hallReservationStatusFieldProvider).state;

    ref.read(addHallStateProvider).state = AsyncLoading();

    if(validateHallData()){
      _repository.addHall(
        hallName,
        hallId,
        hallCapacity,
        hallFreeSeats,
        hallStatus,
        onSuccess: (hall) {
          ref.read(addHallStateProvider).state = AsyncData(0);
          showSnackBar("Building successfully added", Colors.red);

          ref.read(hallNameFieldProvider).state = '';
          ref.read(hallIdFieldProvider).state = '';
          ref.read(hallCapacityFieldProvider).state = '';
          ref.read(hallReservationStatusFieldProvider).state = '';
          ref.read(hallFreeSeatsFieldProvider).state = '';
          getHalls();
        },
        onFailed: (error) {
          ref.read(addHallStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          getHalls();
        },
      );
    }else{
      ref.read(addHallStateProvider).state = AsyncData(0);
    }

  }

  delete(Hall hall) async {
    ref.read(getHallStateProvider).state = AsyncLoading();
    _repository.deleteHall(
      hall,
      onSuccess: (hall) {
        showSnackBar("Hall deleted", Colors.red);
        getHalls();
      },
      onFailed: (error) {
        getHalls();
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }



  updateHall(Hall hall,{required Function(bool isHallUpdated) isHallUpdated}) async {
    ref.read(updateHallStateProvider)
        .state = const AsyncLoading();

    var hallName = ref.read(updateHallNameFieldProvider).state;
    var hallId = ref.read(updateHallIdFieldProvider).state;
    var hallCapacity = ref.read(updateCapacityFieldProvider).state;
    var hallFreeSeats = ref.read(updateFreeSeatsFieldProvider).state;
    var hallStatus = ref.read(updateHallReservationStatusFieldProvider).state;

    if(validateUpdateHall()){
      _repository.updateBuilding(
        hall,
        hallName,
        hallId,
        hallCapacity,
        hallFreeSeats,
        hallStatus,
        onSuccess: (building) {
          ref.read(updateHallNameFieldProvider).state = '';
          ref.read(updateHallIdFieldProvider).state = '' ;
          ref.read(updateCapacityFieldProvider).state = '';
          ref.read(updateHallReservationStatusFieldProvider).state = '' ;
          ref.read(updateFreeSeatsFieldProvider).state = '';
          ref.read(updateHallStateProvider).state = const AsyncData(0);


          showSnackBar("Hall successfully updated", Colors.red);
          isHallUpdated(true);
          getHalls();
        },
        onFailed: (error) {
          ref.read(updateHallStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          isHallUpdated(false);
        },
      );
    }else{
      ref.read(updateHallStateProvider).state = AsyncData(0);
    }

  }

  bool validateHallData() {
    var hallName = ref.read(hallNameFieldProvider).state;
    var hallId = ref.read(hallIdFieldProvider).state;
    var hallCapacity = ref.read(hallCapacityFieldProvider).state;
    var hallFreeSeats = ref.read(hallFreeSeatsFieldProvider).state;
    var hallReservationStatus = ref.read(hallReservationStatusFieldProvider).state;

    if (hallName.isEmpty) {
      showSnackBar("Error: Please enter hall name", Colors.red);
      return false;
    } else if (hallId.isEmpty) {
      showSnackBar("Error: Please enter hall id", Colors.red);
      return false;
    } else if (hallCapacity.isEmpty) {
      showSnackBar("Error: Please enter hall capacity", Colors.red);
      return false;
    } else if (hallReservationStatus.isEmpty) {
      showSnackBar("Error: Please enter hall status", Colors.red);
      return false;
    } else if (hallFreeSeats.isEmpty) {
      showSnackBar("Error: Please enter free seats", Colors.red);
      return false;
    }else {
      return true;
    }
  }

  bool validateUpdateHall() {
    var hallName = ref.read(updateHallNameFieldProvider).state;
    var hallId = ref.read(updateHallIdFieldProvider).state;
    var hallCapacity = ref.read(updateCapacityFieldProvider).state;
    var hallReservationStatus = ref.read(updateHallReservationStatusFieldProvider).state;
    var hallFreeSeats = ref.read(updateFreeSeatsFieldProvider).state;

    if (hallName.isEmpty) {
      showSnackBar("Error: Please enter hall name", Colors.red);
      return false;
    } else if (hallId.isEmpty) {
      showSnackBar("Error: Please enter hall id", Colors.red);
      return false;
    } else if (hallCapacity.isEmpty) {
      showSnackBar("Error: Please enter hall capacity", Colors.red);
      return false;
    } else if (hallReservationStatus.isEmpty) {
      showSnackBar("Error: Please enter hall status", Colors.red);
      return false;
    }  else if (hallFreeSeats.isEmpty) {
      showSnackBar("Error: Please enter hall free seats", Colors.red);
      return false;
    }else {
      return true;
    }
  }

}
