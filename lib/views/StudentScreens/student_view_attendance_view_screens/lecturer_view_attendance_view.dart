import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/attendance.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/lecturer_view_attendance_view_model.dart';
import 'package:uqu_map_app/view_models/student_view_attendance_view_model.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class StudentViewAttendanceView extends StatelessWidget {
  const StudentViewAttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Attendance",StudentViewAttendanceViewBody());
  }
}


class StudentViewAttendanceViewBody extends StatefulWidget {
  const StudentViewAttendanceViewBody({Key? key}) : super(key: key);

  @override
  _StudentViewAttendanceViewBodyState createState() => _StudentViewAttendanceViewBodyState();
}

class _StudentViewAttendanceViewBodyState extends State<StudentViewAttendanceViewBody> {

  late StudentViewAttendanceViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(studentViewAttendanceViewModel.notifier);
    viewModel.getUserAttendance();
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
          Expanded(
            flex: 2,
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
                      return userAttendanceListCard(attendance,userAttendance);
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

  Card userAttendanceListCard(Attendance attendance,UserAttendance userAttendance) {
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

          ],
        ),
      ),
    );
  }

}
