import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/data/SharedPreferencesService.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_view_noticeboard/admin_view_noticeboard.dart';
import 'package:uqu_map_app/views/CommonScreens/edit_profile_view/my_profile_view.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_scan_qr_attendance_view/lecturer_scan_qr_attendance_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_university_map_screens/student_view_university_map_view.dart';
import 'package:uqu_map_app/views/home.dart';
import 'package:uqu_map_app/views/login_screen/login_view.dart';

import '../lecturer_add_noticeboard_notes/lecturer_add_noticeboard_notes_view.dart';
import '../lecturer_manage_halls/lecturer_manage_halls_view.dart';
import '../lecturer_view_attendance/lecturer_view_attendance_view.dart';
import '../lecturer_view_halls/lecturer_view_halls_view.dart';
import '../lecturer_view_schedule_screen/lecturer_view_schedule_view.dart';


class LecturerHome extends StatelessWidget {
  const LecturerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.white,
      resizeToAvoidBottomInset: false,
      // drawer: drawer(viewModel),
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        title: const Text("Lecturer Home"),
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
      body: SafeArea(child: LecturerHomeBody()),
    );
  }
}


class LecturerHomeBody extends StatelessWidget {
  const LecturerHomeBody({Key? key}) : super(key: key);

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
                child: makeDashboardItem("View Schedule", Icons.book_online),
                onTap: (){
                  Get.to(const LecturerViewScheduleView());
                },
              ),

             /* InkWell(
                child: makeDashboardItem("View Halls", Icons.select_all),
                onTap: (){
                  Get.to(const LecturerViewHallsView());
                },
              ),*/

              InkWell(
                child: makeDashboardItem("Reserve Halls", Icons.manage_search_sharp),
                onTap: (){
                  Get.to(const LecturerManageHallsView());
                },
              ),

              InkWell(
                child: makeDashboardItem("View Attendance", Icons.attach_file),
                onTap: (){
                  Get.to(const LecturerViewAttendanceView());
                },
              ),

              InkWell(
                child: makeDashboardItem("Add Noticeboard note", Icons.attach_file),
                onTap: (){
                  Get.to(const AdminViewNoticeboard());

//                  Get.to(const LecturerAddNoticeboardNotesView());
                },
              ),

          /*    InkWell(
                child: makeDashboardItem("University Map", Icons.map),
                onTap: () {
                  Get.to(const StudentViewUniversityMapView());
                },
              ),
*/
              InkWell(
                child: makeDashboardItem("Attendance", Icons.attach_file),
                onTap: (){
                  Get.to(const LecturerScanQRAttendanceView());
                },
              ),

              InkWell(
                child: makeDashboardItem("My Profile", Icons.people),
                onTap: (){
                  Get.to(const MyProfileView());
                },
              ),

        /*      InkWell(
                child: makeDashboardItem("Logout", Icons.logout),
                onTap: (){
                  SharedPreferencesService sharedPreferencesService = Get.find();
                  sharedPreferencesService.saveToDisk(Strings.userPrefKEY, "null");
                  Get.to(const LoginView());
                },
              ),*/


            ],
          ),
        ),
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
