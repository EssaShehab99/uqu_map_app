import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/attendance.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/view_models/admin_view_student_attendance_view_model.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class AdminViewStudentAttendance extends StatelessWidget {
  const AdminViewStudentAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Student Attendance",AdminViewStudentAttendanceBody());
  }

}

class AdminViewStudentAttendanceBody extends StatefulWidget {
  const AdminViewStudentAttendanceBody({Key? key}) : super(key: key);

  @override
  _AdminViewStudentAttendanceBodyState createState() => _AdminViewStudentAttendanceBodyState();
}

class _AdminViewStudentAttendanceBodyState extends State<AdminViewStudentAttendanceBody> {

  late AdminViewStudentAttendanceViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(adminViewStudentAttendanceViewModel.notifier);
    viewModel.getAllUsers();
    //viewModel.addAttendance();
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
                  SizedBox(
                    height: 10,
                  ),
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
                  viewAttendanceButton(viewModel, user),
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

  Widget viewAttendanceButton(AdminViewStudentAttendanceViewModel viewModel, User user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  child: Text("View",
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.white, 12, FontWeight.bold)),
                  onPressed: () {
                    viewModel.getUserAttendance(user);
                    showDialog(
                        context: context,
                        builder: (context) =>
                            _onTapAttendanceList(context,user));
                    },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onTapAttendanceList(BuildContext context,User user) {
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
                title: Text("${user.userName} Attendance"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              Expanded(
                flex: 3,
                child: Consumer(
                  builder: (context, watch, child) {
                    AsyncValue userAttendance =
                        watch(viewModel.getUserAttendanceStateProvider).state;
                    return userAttendance.when(data: (dynamic value) {
                      Attendance attendance = value;
                      List<UserAttendance> attendanceList = attendance.userAttendance!;
                      return ListView.builder(
                        itemCount: attendanceList.length,
                        itemBuilder: (context, i) {
                          UserAttendance userAttendance = attendanceList[i];
                          return userAttendanceListCard(user,attendance,userAttendance);
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
          /*viewModel.updateUser(user,isUserUpdated: (isUserUpdated) {
            if(isUserUpdated){
              Navigator.pop(context);
            }
          });*/
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
         /* context.read(viewModel.updateFirstNameFieldProvider).state = '';
          context.read(viewModel.updateLastNameFieldProvider).state = '';
          context.read(viewModel.updateEmailFieldProvider).state = '';
          context.read(viewModel.updatePasswordFieldProvider).state = '';*/
          Navigator.pop(context);
        },
      ),
    );
  }

  Card userAttendanceListCard(User user,Attendance attendance,UserAttendance userAttendance) {
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
                      'Date: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${userAttendance.dateTime}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.normal),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
/*                  Row(children: [
                    Text(
                      'Check: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${hall.hallName}',
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
                      'Capacity: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${hall.capacity}',
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
                      'Status: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${hall.status}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.normal),
                    ),
                  ]),*/
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
                  deleteButton(user,attendance,userAttendance),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget deleteButton(User user,Attendance attendance,UserAttendance userAttendance) {
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
                   viewModel.delete(user,attendance,userAttendance);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


}