
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_schedule_information_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_time_slot_information_repository.dart';
import '../repositories/admin_manage_hall_information_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final adminManageScheduleInformationRepository =
StateNotifierProvider<AdminManageTimeSlotInformationViewModel, Map<String, dynamic>>(
        (ref) => AdminManageTimeSlotInformationViewModel(ref));

class AdminManageTimeSlotInformationViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminManageTimeSlotInformationViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminManageTimeSlotInformationRepository _repository = AdminManageTimeSlotInformationRepository();

  final userStateProvider =
  StateProvider<User>((ref) => User());

  getLoggedUser() async{

  }


}
