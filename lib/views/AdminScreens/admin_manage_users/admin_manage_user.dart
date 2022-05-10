import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/admin_manage_users_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class AdminManageUsersView extends StatelessWidget {
  const AdminManageUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      resizeToAvoidBottomInset: false,
      // drawer: drawer(viewModel),
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        title: const Text("Manage Users"),
        centerTitle: true,
        actions: const [],
      ),
      body: const SafeArea(child: AdminManageUserBody()),
    );
  }

}

class AdminManageUserBody extends StatefulWidget {
  const AdminManageUserBody({Key? key}) : super(key: key);

  @override
  State<AdminManageUserBody> createState() => _AdminManageUserBodyState();
}

class _AdminManageUserBodyState extends State<AdminManageUserBody> {
  late final AdminManageUsersViewModel viewModel;

  @override
  void initState() {
    viewModel = context.read(adminManageUsersViewModel.notifier);
    viewModel.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: textFieldsRow(
                      "First name",
                      "Last name",
                      viewModel.firstNameFieldProvider,
                      viewModel.lastNameFieldProvider),
                ),
                Expanded(
                  flex: 1,
                  child: textFieldsRow(
                      "Email",
                      "Username",
                      viewModel.emailFieldProvider,
                      viewModel.userNameFieldProvider),
                ),
                Expanded(
                  flex: 1,
                  child: textFieldAndDropDown(
                      context,
                      "Password",
                      "Role: ${Strings.studentRole} Or ${Strings.lecturerRole}",
                      viewModel.passwordFieldProvider,
                      viewModel.roleFieldProvider),
                ),
                SizedBox(height: 4,),
                Expanded(
                  flex: 1,
                  child: Consumer(
                    builder: (context, watch, child) {
                      AsyncValue addUserState =
                          watch(viewModel.addUserStateProvider).state;
                      return addUserState.when(data: (dynamic value) {
                        return addUserButton(viewModel);
                      }, error: (Object error, StackTrace? stackTrace) {
                        return addUserButton(viewModel);
                      }, loading: () {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.kPrimaryColor),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Consumer(
              builder: (context, watch, child) {
                AsyncValue usersState =
                    watch(viewModel.getUsersStateProvider).state;
                return usersState.when(data: (dynamic value) {
                  List<User> usersList = value;
                  return ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (context, i) {
                      User user = usersList[i];

                      return usersListCard(user);
                    },
                  );
                }, error: (Object error, StackTrace? stackTrace) {
                  return Center(
                      child: Text("No data found",
                          style: AppStyles.appSubHeadingTextStyle(
                              AppColor.kAccentColorLight,
                              16.0,
                              FontWeight.bold)));
                }, loading: () {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColor.kPrimaryColor),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Card usersListCard(User user) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Row(children: [
                    Text(
                      'First name: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${user.firstName}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.normal),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Text(
                      'Last name: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${user.lastName}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.normal),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Username: ',
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.bold),
                      ),
                      Text(
                        '${user.userName}',
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.bold),
                      ),
                      Text(
                        '${user.email}',
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Role: ',
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.bold),
                      ),
                      Text(
                        '${user.role}',
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'QR Image: ',
                    style: AppStyles.appSubHeadingTextStyle(
                        AppColor.kAccentColorLight, 14, FontWeight.bold),
                  ),
                  QrImage(
                    data: user.userName.toString(),
                    version: QrVersions.auto,
                    size: 100.0,
                  ),

                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  editButton(viewModel, user),
                  const SizedBox(
                    height: 10,
                  ),
                  deleteButton(viewModel, user),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row textFieldsRow(String field1Label, String field2Label,
      StateProvider stateProviderField1, StateProvider stateProviderField2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  field1Label, false, false, false, stateProviderField1),
            ],
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  field2Label, false, false, false, stateProviderField2),
            ],
          ),
        ),
      ],
    );
  }

  Row textFieldAndDropDown(
      BuildContext context,
      String field1Label,
      String field2Label,
      StateProvider stateProviderField1,
      StateProvider stateProviderField2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                  field1Label, false, false, false, stateProviderField1),
            ],
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: DropDown(
                  items: const [Strings.studentRole, Strings.lecturerRole],
                  hint: const Text(
                    "Select Role",
                    style: TextStyle(color: AppColor.kAccentColorLight),
                  ),
                  icon: const Icon(
                    Icons.expand_more,
                    color: Colors.blue,
                  ),
                  onChanged: (text) {
                    context.read(stateProviderField2).state = text;
                  },
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.kAccentColorLight)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addUserButton(AdminManageUsersViewModel viewModel) {
    return Column(
      children: [
        const SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            const SizedBox(
              width: 5.0,
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  child: const Text("Add User"),
                  onPressed: () {
                    viewModel.addUserUsers();
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  Widget editButton(AdminManageUsersViewModel viewModel, User user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  child: Text("Update",
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.white, 12, FontWeight.bold)),
                  onPressed: () {
                    context.read(viewModel.updateFirstNameFieldProvider).state = user.firstName!;
                    context.read(viewModel.updateLastNameFieldProvider).state = user.lastName! ;
                    context.read(viewModel.updateEmailFieldProvider).state = user.email!;
                    context.read(viewModel.updatePasswordFieldProvider).state = user.password!;

                    showDialog(
                        context: context,
                        builder: (context) =>
                            _onTapUpdateUser(context,user)); // Call the Dialog.
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget deleteButton(AdminManageUsersViewModel viewModel, User user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text("Delete",
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.white, 12, FontWeight.bold)),
                  onPressed: () {
                    viewModel.deleteUsers(user);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onTapUpdateUser(BuildContext context,User user) {
    return Scaffold(
      body : WillPopScope(
        onWillPop: () async => true,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBar(
                backgroundColor: AppColor.appThemeColor,
                title: const Text("Update User"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 20.0,
                  onPressed: () {
                    context.read(viewModel.updateFirstNameFieldProvider).state = '';
                    context.read(viewModel.updateLastNameFieldProvider).state = '';
                    context.read(viewModel.updateEmailFieldProvider).state = '';
                    context.read(viewModel.updatePasswordFieldProvider).state = '';
                    Navigator.pop(context);
                  },
                ),
              ),


              Expanded(
                flex: 3,
                child: Container(
                  padding:
                  const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  child: ListView(
                    children: [
                      AppStyles.textFieldTitleText('First Name'),
                      const SizedBox(height: 10),
                      CustomTextField(
                          "", false, false, false, viewModel.updateFirstNameFieldProvider),
                      const SizedBox(height: 10),
                      AppStyles.textFieldTitleText('Last Name'),
                      const SizedBox(height: 10),
                      CustomTextField("", false, false, false,
                          viewModel.updateLastNameFieldProvider),
                      const SizedBox(height: 10),
                      AppStyles.textFieldTitleText('Email'),
                      const SizedBox(height: 10),
                      CustomTextField("", false, false, false,
                          viewModel.updateEmailFieldProvider),
                      const SizedBox(height: 10),
                      AppStyles.textFieldTitleText('Password'),
                      const SizedBox(height: 10),
                      CustomTextField("", true, true, true,
                          viewModel.updatePasswordFieldProvider),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: closeButton(),
                          ),

                          SizedBox(width: 10,),

                          Expanded(
                              flex: 1,
                              child: Consumer(
                                builder: (context, watch, child) {
                                  AsyncValue loginState = watch(viewModel.updateUserStateProvider).state;
                                  return loginState.when(data: (dynamic value) {
                                    return updateProfileButton(user);
                                  }, error: (Object error, StackTrace? stackTrace) {
                                    return updateProfileButton(user);
                                  }, loading: () {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.kPrimaryColor),
                                      ),
                                    );
                                  });
                                },
                              ),)
                        ],
                      )


                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox updateProfileButton(User user) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: const Text("Update User"),
        onPressed: () async {
          viewModel.updateUser(user,isUserUpdated: (isUserUpdated) {
            if(isUserUpdated){
              Navigator.pop(context);
            }
          });
        },
      ),
    );
  }

  SizedBox closeButton() {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: const Text("Cancel"),
        onPressed: () {
          context.read(viewModel.updateFirstNameFieldProvider).state = '';
          context.read(viewModel.updateLastNameFieldProvider).state = '';
          context.read(viewModel.updateEmailFieldProvider).state = '';
          context.read(viewModel.updatePasswordFieldProvider).state = '';
          Navigator.pop(context);
        },
      ),
    );
  }
}
