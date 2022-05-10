import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/data/SharedPreferencesService.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/views/CommonScreens/edit_profile_view/my_profile_view.dart';
import 'package:uqu_map_app/views/StudentScreens/attendance_qr/attendance_qr.dart';
import 'package:uqu_map_app/views/StudentScreens/student_scan_qr_attendance_view_screens/student_scan_qr_attendance_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_attendance_view_screens/lecturer_view_attendance_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_noticeboard_screens/stuend_view_noticeboard_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_schedule_information_screens/student_view_schedule_information_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_university_map_screens/student_view_university_map_view.dart';
import 'package:uqu_map_app/views/home.dart';
import 'package:uqu_map_app/views/login_screen/login_view.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      resizeToAvoidBottomInset: false,
      // drawer: drawer(viewModel),
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        title: const Text("Student Home"),
        centerTitle: true,
        actions: [
          InkWell(
            child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: const Icon(Icons.logout)),
            onTap: () {
              SharedPreferencesService sharedPreferencesService = Get.find();
              sharedPreferencesService.saveToDisk(Strings.userPrefKEY, "null");
              Get.to(const Home());
            },
          ),
        ],
      ),
      body: SafeArea(child: StudentHomeBody()),
    );
  }
}

class StudentHomeBody extends StatelessWidget {
  const StudentHomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Expanded(
            flex: 1,
            child: GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  InkWell(
                    child:
                        makeDashboardItem("View Schedule", Icons.book_online),
                    onTap: () {
                      Get.to(const StudentViewScheduleInformationView());
                    },
                  ),
                  InkWell(
                    child: makeDashboardItem("Noticeboard", Icons.book_online),
                    onTap: () {
                      Get.to(const StudentViewNoticeboardView());
                    },
                  ),
                  InkWell(
                    child: makeDashboardItem("View Attendance", Icons.attach_file),
                    onTap: () {
                      Get.to(const StudentViewAttendanceView());
                    },
                  ),

                  InkWell(
                    child: makeDashboardItem("Attendance QR", Icons.attach_file),
                    onTap: () {
                      Get.to(const AttendanceQR());
                    },
                  ),

                  /*InkWell(
                    child: makeDashboardItem("Test Attendance", Icons.map),
                    onTap: () {
                      Get.to(const StudentScanQrAttendanceView());
                    },
                  ),*/
                  InkWell(
                    child: makeDashboardItem("My Profile", Icons.people),
                    onTap: () {
                      Get.to(const MyProfileView());
                    },
                  ),
                ]))
      ],
    );
  }

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: const EdgeInsets.all(8.0),
        color: AppColor.kPrimaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.appThemeColor,
            //const Color.fromRGBO(220, 220, 220, 1.0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              const SizedBox(height: 20.0),
              Center(
                  child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.white,
                  )),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Center(
                  child: Text(title,
                      style:
                      const TextStyle(fontSize: 8.0, color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ));
  }
}
