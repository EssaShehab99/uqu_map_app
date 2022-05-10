

import 'package:flutter/material.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/login_repository.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_home/admin_home.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_home/lecturer_home.dart';
import 'package:uqu_map_app/views/StudentScreens/student_home/student_home.dart';
import 'package:uqu_map_app/views/admin_home_view.dart';
import 'package:uqu_map_app/views/lecturer_home_view.dart';

import '../views/student_home_view.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final loginViewModel =
StateNotifierProvider<LoginViewModel, Map<String, dynamic>>(
        (ref) => LoginViewModel(ref));

class LoginViewModel extends BaseViewModel<Map<String, dynamic>> {

  LoginViewModel(this.ref,) : super({});
  ProviderReference ref;

  final LoginRepository _repository = LoginRepository();

  final userNameStateProvider = StateProvider<String>((ref) {
    return "";//"Admin";
  });

  final passwordStateProvider = StateProvider<String>((ref) {
    return "";//"Admin";
  });


  final loginStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  loginUser(){

  }


  Future<User?> login() async {
    ref.read(loginStateProvider)
        .state = const AsyncLoading();

    var userName = ref
        .read(userNameStateProvider)
        .state;
    var password = ref
        .read(passwordStateProvider)
        .state;



    if(validateUser()){
      _repository.login(userName, password,
          onSuccess: (user) {
            ref.read(loginStateProvider).state = AsyncData(0);
            showSnackBar("Login Success", Colors.blue);

            if(user.role == Strings.adminRole){
              Get.offAll(const AdminHomeView());
            }else if(user.role == Strings.lecturerRole){
              Get.offAll(const LecturerHomeView());
            }else if(user.role == Strings.studentRole){
              Get.offAll(const StudentHomeView());
            }

          },
          onFailed: (error) {
            ref.read(loginStateProvider).state = AsyncError(3);
            showSnackBar("Error: $error", Colors.red);
          },
      );
    }else{
      ref.read(loginStateProvider).state = AsyncError(3);
    }

    return Future.value(User());

  }

  bool validateUser() {
    var userName = ref
        .read(userNameStateProvider)
        .state;
    var password = ref
        .read(passwordStateProvider)
        .state;

    if (userName.isNotEmpty && password.isNotEmpty) {
      return true;
    } else {
      showSnackBar("Error: Please enter valid credentials", Colors.red);
      return false;
    }
  }

  addUser(){
    _repository.addUser();
  }


}
