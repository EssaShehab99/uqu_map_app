
import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final adminManageBuildingsInformationViewModel =
StateNotifierProvider<AdminManageHallsInformationViewModel, Map<String, dynamic>>(
        (ref) => AdminManageHallsInformationViewModel(ref));

class AdminManageHallsInformationViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminManageHallsInformationViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminManageBuildingsInformationRepository _repository = AdminManageBuildingsInformationRepository();

  final buildingNameFieldProvider = StateProvider<String>((ref) => "");
  final updateBuildingNameFieldProvider = StateProvider<String>((ref) => "");

  final buildingIdFieldProvider = StateProvider<String>((ref) => "");
  final updateBuildingIdFieldProvider = StateProvider<String>((ref) => "");

  final addBuildingStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  final updateBuildingStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

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

  addBuilding(){
    var buildingName = ref.read(buildingNameFieldProvider).state;
    var buildingId = ref.read(buildingIdFieldProvider).state;
    ref.read(addBuildingStateProvider).state = AsyncLoading();
    if(validateBuildingsData()){
      _repository.addBuilding(
        buildingName,
        buildingId,
        onSuccess: (user) {
          ref.read(addBuildingStateProvider).state = AsyncData(0);
          showSnackBar("Building successfully added", Colors.red);

          ref.read(buildingNameFieldProvider).state = '';
          ref.read(buildingIdFieldProvider).state = '';
          getBuildings();
        },
        onFailed: (error) {
          ref.read(addBuildingStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          getBuildings();
        },
      );
    }else{
      ref.read(addBuildingStateProvider).state = AsyncData(0);
    }

  }

  delete(Building building) async {
    ref.read(getBuildingsStateProvider).state = AsyncLoading();
    _repository.deleteBuilding(
      building,
      onSuccess: (user) {
        showSnackBar("Building deleted", Colors.red);
        getBuildings();
      },
      onFailed: (error) {
        getBuildings();
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  bool validateBuildingsData() {
    var buildingName = ref.read(buildingNameFieldProvider).state;
    var buildingId = ref.read(buildingIdFieldProvider).state;

    if (buildingName.isEmpty) {
      showSnackBar("Error: Please enter building name", Colors.red);
      return false;
    } else if (buildingId.isEmpty) {
      showSnackBar("Error: Please enter building id", Colors.red);
      return false;
    } else {
      return true;
    }
  }

  bool validateUpdateBuilding() {
    var buildingName = ref.read(updateBuildingNameFieldProvider).state;
    var buildingId = ref.read(updateBuildingIdFieldProvider).state;

    if (buildingName.isEmpty) {
      showSnackBar("Error: Please enter building name", Colors.red);
      return false;
    } else if (buildingId.isEmpty) {
      showSnackBar("Error: Please enter building id", Colors.red);
      return false;
    } else {
      return true;
    }
  }

  updateBuilding(Building building,{required Function(bool isBuildingUpdated) isBuildingUpdated}) async {
    ref.read(updateBuildingStateProvider)
        .state = const AsyncLoading();

    var buildingName = ref.read(updateBuildingNameFieldProvider).state;
    var buildingId = ref.read(updateBuildingIdFieldProvider).state;

    if(validateUpdateBuilding()){
      _repository.updateBuilding(building, buildingName,building.buildingId!,
        onSuccess: (building) {
          ref.read(updateBuildingNameFieldProvider).state = '';
          ref.read(updateBuildingIdFieldProvider).state = '' ;
          ref.read(updateBuildingStateProvider).state = const AsyncData(0);

          showSnackBar("Building successfully updated", Colors.red);
          isBuildingUpdated(true);
          getBuildings();
        },
        onFailed: (error) {
          ref.read(updateBuildingStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          isBuildingUpdated(false);
        },
      );
    }else{
      ref.read(addBuildingStateProvider).state = AsyncData(0);
    }

  }

}
