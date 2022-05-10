

import 'package:flutter/material.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/login_repository.dart';
import 'package:uqu_map_app/repositories/my_profile_repository.dart';

import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final myProfileViewModel =
StateNotifierProvider<MyProfileViewModel, Map<String, dynamic>>(
        (ref) => MyProfileViewModel(ref));

class MyProfileViewModel extends BaseViewModel<Map<String, dynamic>> {

  MyProfileViewModel(this.ref,) : super({});
  ProviderReference ref;

  final MyProfileRepository _repository = MyProfileRepository();

  final firstNameStateProvider = StateProvider<String>((ref) {
    return "";
  });

  final lastNameStateProvider = StateProvider<String>((ref) {
    return "";
  });

  final emailStateProvider = StateProvider<String>((ref) {
    return "";
  });

  final passwordStateProvider = StateProvider<String>((ref) {
    return "";
  });


  final updateProfileStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  getLoggedUser() async{
    User? user = await _repository.getLoggedUser();
    if(user !=null){
      print('Logged User ${user.toJson()}');

      ref.read(firstNameStateProvider)
          .state = user.firstName!;

      ref.read(lastNameStateProvider)
          .state = user.lastName!;

      ref.read(emailStateProvider)
          .state = user.email!;

      ref.read(passwordStateProvider)
          .state = user.password!;

    }else{
      print("User not logged in");
    }
  }

  updateProfile() async {
    ref.read(updateProfileStateProvider)
        .state = const AsyncLoading();

    var firstName = ref
        .read(firstNameStateProvider)
        .state;

    var lastName = ref
        .read(lastNameStateProvider)
        .state;

    var email = ref
        .read(emailStateProvider)
        .state;


    var password = ref
        .read(passwordStateProvider)
        .state;



    if(validateUser()){
      _repository.updateProfile(firstName,lastName,email, password,
        onSuccess: (user) {
          ref.read(updateProfileStateProvider).state = AsyncData(0);
          showSnackBar("Profile successfully updated", Colors.red);
        },
        onFailed: (error) {
          ref.read(updateProfileStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
        },
      );
    }else{
      ref.read(updateProfileStateProvider).state = AsyncError(3);
    }

    return Future.value(User());

  }

  bool validateUser() {
    ref.read(updateProfileStateProvider)
        .state = const AsyncLoading();

    var firstName = ref
        .read(firstNameStateProvider)
        .state;

    var lastName = ref
        .read(lastNameStateProvider)
        .state;

    var email = ref
        .read(emailStateProvider)
        .state;

    var password = ref
        .read(passwordStateProvider)
        .state;

    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      return true;
    } else {
      showSnackBar("Error: Please enter valid data", Colors.red);
      return false;
    }
  }

}
