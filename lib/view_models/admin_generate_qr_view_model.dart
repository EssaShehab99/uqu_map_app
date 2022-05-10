
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final adminGenerateQRViewModel =
StateNotifierProvider<AdminGenerateQRViewModel, Map<String, dynamic>>(
        (ref) => AdminGenerateQRViewModel(ref));

class AdminGenerateQRViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminGenerateQRViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminGenerateQRRepository _repository = AdminGenerateQRRepository();

  final userStateProvider =
  StateProvider<User>((ref) => User());

  getLoggedUser() async{

  }


}
