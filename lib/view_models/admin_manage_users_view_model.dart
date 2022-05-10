import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_manage_users_repository.dart';

import 'base_view_model.dart';

final adminManageUsersViewModel =
    StateNotifierProvider<AdminManageUsersViewModel, Map<String, dynamic>>(
        (ref) => AdminManageUsersViewModel(ref));

class AdminManageUsersViewModel extends BaseViewModel<Map<String, dynamic>> {
  AdminManageUsersViewModel(
    this.ref,
  ) : super({});
  ProviderReference ref;

  final AdminManageUsersRepository _repository = AdminManageUsersRepository();

  final firstNameFieldProvider = StateProvider<String>((ref) => "");
  final updateFirstNameFieldProvider = StateProvider<String>((ref) => "");


  final lastNameFieldProvider = StateProvider<String>((ref) => "");
  final updateLastNameFieldProvider = StateProvider<String>((ref) => "");

  final emailFieldProvider = StateProvider<String>((ref) => "");
  final updateEmailFieldProvider = StateProvider<String>((ref) => "");

  final userNameFieldProvider = StateProvider<String>((ref) => "");

  final passwordFieldProvider = StateProvider<String>((ref) => "");
  final updatePasswordFieldProvider = StateProvider<String>((ref) => "");

  final roleFieldProvider = StateProvider<String>((ref) => "");

  final addUserStateProvider =
      StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  final updateUserStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  final getUsersStateProvider =
      StateProvider<AsyncValue<List<User>>>((ref) => AsyncLoading());

  addUserUsers() async {
    ref.read(addUserStateProvider).state = const AsyncLoading();

    var firstName = ref.read(firstNameFieldProvider).state;
    var lastName = ref.read(lastNameFieldProvider).state;
    var email = ref.read(emailFieldProvider).state;
    var userName = ref.read(userNameFieldProvider).state;
    var password = ref.read(passwordFieldProvider).state;
    var role = ref.read(roleFieldProvider).state;

    print('role $role');

    if (validateUser()) {
      print('firstName $firstName');
      print('lastName $lastName');
      print('email $email');
      print('userName $userName');
      print('password $password');
      print('role $role');

      _repository.addUser(
        firstName,
        lastName,
        email,
        userName,
        role,
        password,
        onSuccess: (user) {
          ref.read(addUserStateProvider).state = AsyncData(0);
          showSnackBar("User successfully added", Colors.red);

          ref.read(firstNameFieldProvider).state = '';
          ref.read(lastNameFieldProvider).state = '';
          ref.read(emailFieldProvider).state = '';
          ref.read(userNameFieldProvider).state = '';
          ref.read(passwordFieldProvider).state = '';

          getAllUsers();
        },
        onFailed: (error) {
          ref.read(addUserStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
        },
      );
    } else {
      ref.read(addUserStateProvider).state = AsyncError(3);
    }
  }

  getAllUsers()  {
    _repository.getAllUsers(
      onSuccess: (users) {
        ref.read(getUsersStateProvider).state = AsyncData(users);
      },
      onFailed: (error) {
        ref.read(getUsersStateProvider).state = AsyncError(3);
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  bool validateUser() {
    var firstName = ref.read(firstNameFieldProvider).state;
    var lastName = ref.read(lastNameFieldProvider).state;
    var email = ref.read(emailFieldProvider).state;
    var userName = ref.read(userNameFieldProvider).state;
    var password = ref.read(passwordFieldProvider).state;
    var role = ref.read(roleFieldProvider).state;

    if (firstName.isEmpty) {
      showSnackBar("Error: Please enter first name", Colors.red);
      return false;
    } else if (lastName.isEmpty) {
      showSnackBar("Error: Please enter last name", Colors.red);
      return false;
    } else if (email.isEmpty) {
      showSnackBar("Error: Please enter email", Colors.red);
      return false;
    } else if (!isEmail(email)) {
      showSnackBar("Error: Please valid enter email", Colors.red);
      return false;
    } else if (userName.isEmpty) {
      showSnackBar("Error: Please enter user name", Colors.red);
      return false;
    } else if (password.isEmpty) {
      showSnackBar("Error: Please enter password", Colors.red);
      return false;
    } else if (role.isEmpty) {
      showSnackBar("Error: Please select role", Colors.red);
      return false;
    } else {
      return true;
    }
  }

  bool validateUpdateRequest() {
    var firstName = ref.read(updateFirstNameFieldProvider).state;
    var lastName = ref.read(updateLastNameFieldProvider).state;
    var email = ref.read(updateEmailFieldProvider).state;
    var password = ref.read(updatePasswordFieldProvider).state;


    if (firstName.isEmpty) {
      showSnackBar("Error: Please enter first name", Colors.red);
      return false;
    } else if (lastName.isEmpty) {
      showSnackBar("Error: Please enter last name", Colors.red);
      return false;
    } else if (email.isEmpty) {
      showSnackBar("Error: Please enter email", Colors.red);
      return false;
    } else if (!isEmail(email)) {
      showSnackBar("Error: Please valid enter email", Colors.red);
      return false;
    }  else if (password.isEmpty) {
      showSnackBar("Error: Please enter password", Colors.red);
      return false;
    } else {
      return true;
    }
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  deleteUsers(User user) async {
    ref.read(getUsersStateProvider).state = AsyncLoading();
    _repository.deleteUser(
      user,
      onSuccess: (user) {
        showSnackBar("User deleted", Colors.red);
        getAllUsers();
      },
      onFailed: (error) {
        getAllUsers();
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  updateUser(User user,{required Function(bool isUserUpdated) isUserUpdated}) async {
    ref.read(updateUserStateProvider)
        .state = const AsyncLoading();

    var firstName = ref.read(updateFirstNameFieldProvider).state;
    var lastName = ref.read(updateLastNameFieldProvider).state;
    var email = ref.read(updateEmailFieldProvider).state;
    var password = ref.read(updatePasswordFieldProvider).state;

    if(validateUpdateRequest()){
      _repository.updateUser(user, firstName,lastName,email, password,
        onSuccess: (user) {
          ref.read(updateFirstNameFieldProvider).state = '';
          ref.read(updateLastNameFieldProvider).state = '' ;
          ref.read(updateEmailFieldProvider).state = '';
          ref.read(updatePasswordFieldProvider).state = '';

          ref.read(updateUserStateProvider).state = const AsyncData(0);

          showSnackBar("User successfully updated", Colors.red);
          isUserUpdated(true);
          getAllUsers();
        },
        onFailed: (error) {
          ref.read(updateUserStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          isUserUpdated(false);
        },
      );
    }else{
      isUserUpdated(false);
      ref.read(updateUserStateProvider).state = AsyncError(3);
    }

    return Future.value(User());

  }
}
