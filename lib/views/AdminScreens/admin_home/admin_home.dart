import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/data/SharedPreferencesService.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/admin_home_view_model.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_buildings_information/admin_manage_buildings_information.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_hall_information/admin_manage_hall_information.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_schedule_information/admin_manage_schedule_information.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_users/admin_manage_user.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_view_lecturer_attendance/admin_view_lecturer_attendance.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_view_noticeboard/admin_view_noticeboard.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_view_student_attendance/admin_view_student_attendance.dart';
import 'package:uqu_map_app/views/CommonScreens/edit_profile_view/my_profile_view.dart';
import 'package:uqu_map_app/views/home.dart';
import 'package:uqu_map_app/views/login_screen/login_view.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';
import 'package:latlong2/latlong.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read(adminHomeViewModel.notifier);
    viewModel.getLoggedUser();
    return Scaffold(
      backgroundColor: AppColor.white,
      resizeToAvoidBottomInset: false,
      // drawer: drawer(viewModel),
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        title: const Text("Dashboard"),
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
      body:  SafeArea(child: AdminHomeBody()),
    );
  }

  Drawer drawer(AdminHomeViewModel viewModel) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColor.appThemeColor,
            ),
            child: Center(
              child: Consumer(
                builder: (context, watch, child) {
                  User user = watch(viewModel.userStateProvider).state;
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Welcome",
                          style: AppStyles.appSubHeadingTextStyle(
                              Colors.white, 16, FontWeight.normal)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(user.firstName! + " " + user.lastName!,
                          style: AppStyles.appSubHeadingTextStyle(
                              Colors.white, 12, FontWeight.normal)),
                    ],
                  );
                },
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Logout',
                style: AppStyles.appSubHeadingTextStyle(
                    Colors.black, 16, FontWeight.bold)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class AdminHomeBody extends StatelessWidget {
   AdminHomeBody({Key? key}) : super(key: key);
   LatLng? latLng = LatLng(51.5, -0.09);

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
                child: makeDashboardItem("Manage Users", Icons.people_alt_outlined),
                onTap: () {
                  Get.to(const AdminManageUsersView());
                },
              ),

              InkWell(
                child: makeDashboardItem("Manage Buildings", Icons.stacked_line_chart),
                onTap: () {
                  Get.to(const AdminManageBuildingsInformation());
                },
              ),

              InkWell(
                child: makeDashboardItem("Manage Hall", Icons.stacked_line_chart),
                onTap: () {
                  Get.to(const AdminManageHallInformation());
                },
              ),

              InkWell(
                child:   makeDashboardItem("Manage Schedules", Icons.stacked_line_chart),
                onTap: () {
                  Get.to(const AdminManageScheduleInformation());
                },
              ),

              InkWell(
                child: makeDashboardItem("Manage Noticeboard", Icons.stacked_line_chart),
                onTap: () {
                  Get.to(const AdminViewNoticeboard());
                },
              ),

              InkWell(
                child:  makeDashboardItem("View Student Attendance", Icons.stacked_line_chart),
                onTap: () {
                  Get.to(const AdminViewStudentAttendance());
                },
              ),

              InkWell(
                child:  makeDashboardItem(
                    "View Lecturer Attendance", Icons.stacked_line_chart),
                onTap: () {
                  Get.to(const AdminViewLecturerAttendance());
                },
              ),

          //    makeDashboardItem("Manage Students", Icons.stacked_line_chart),

//              makeDashboardItem("View Notice Board", Icons.stacked_line_chart),

              InkWell(
                child: makeDashboardItem("My Profile", Icons.people),
                onTap: () {
                  Get.to(const MyProfileView());
                },
              ),

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
