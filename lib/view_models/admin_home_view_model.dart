
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final adminHomeViewModel =
StateNotifierProvider<AdminHomeViewModel, Map<String, dynamic>>(
        (ref) => AdminHomeViewModel(ref));

class AdminHomeViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminHomeViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminHomeRepository _repository = AdminHomeRepository();

  final userStateProvider =
  StateProvider<User>((ref) => User());

  getLoggedUser() async{
    User? user = await _repository.getLoggedUser();
    if(user !=null){
      print('Logged User ${user.toJson()}');
      ref.read(userStateProvider)
          .state = user;
    }else{
      ref.read(userStateProvider)
          .state = User();

    }
  }


}
