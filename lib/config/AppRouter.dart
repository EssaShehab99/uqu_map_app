import 'package:get/get.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_home/admin_home.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_buildings_information/admin_manage_buildings_information.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_hall_information/admin_manage_hall_information.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_schedule_information/admin_manage_schedule_information.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_time_slot_information/admin_manage_time_slot_information.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_manage_users/admin_manage_user.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_view_lecturer_attendance/admin_view_lecturer_attendance.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_view_noticeboard/admin_view_noticeboard.dart';
import 'package:uqu_map_app/views/AdminScreens/admin_view_student_attendance/admin_view_student_attendance.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_add_noticeboard_notes/lecturer_add_noticeboard_notes_view.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_home/lecturer_home.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_manage_halls/lecturer_manage_halls_view.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_scan_qr_attendance_view/lecturer_scan_qr_attendance_view.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_view_attendance/lecturer_view_attendance_view.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_view_halls/lecturer_view_halls_view.dart';
import 'package:uqu_map_app/views/LecturerScreens/lecturer_view_schedule_screen/lecturer_view_schedule_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_home/student_home.dart';
import 'package:uqu_map_app/views/StudentScreens/student_scan_qr_attendance_view_screens/student_scan_qr_attendance_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_attendance_view_screens/lecturer_view_attendance_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_schedule_information_screens/student_view_schedule_information_view.dart';
import 'package:uqu_map_app/views/StudentScreens/student_view_university_map_screens/student_view_university_map_view.dart';
import 'package:uqu_map_app/views/home.dart';
import 'package:uqu_map_app/views/login_screen/login_view.dart';
import 'package:uqu_map_app/views/splash_screen/splash_view.dart';

import '../views/StudentScreens/student_view_noticeboard_screens/stuend_view_noticeboard_view.dart';
import 'RoutesGenerator.dart';

class AppRouter {
  static List<GetPage> router() {
    return [
      GetPage(
          name: RoutesGenerator.SplashRoute, page: () => const SplashView()),
      GetPage(
          name: RoutesGenerator.LoginViewRoute, page: () => const LoginView()),
      GetPage(
          name: RoutesGenerator.AdminHomeViewRoute,
          page: () => const AdminHome()),
      GetPage(
          name: RoutesGenerator.LecturerHomeViewRoute,
          page: () => const LecturerHome()),
      GetPage(
          name: RoutesGenerator.StudentHomeViewRoute,
          page: () => const StudentHome()),
      GetPage(
          name: RoutesGenerator.AdminManageUsers,
          page: () => const AdminManageUsersView()),
      GetPage(
          name: RoutesGenerator.AdminManageBuldingsInfomation,
          page: () => const AdminManageBuildingsInformation()),
      GetPage(
          name: RoutesGenerator.AdminManageHallInformation,
          page: () => const AdminManageHallInformation()),
      GetPage(
          name: RoutesGenerator.AdminViewNoticeboard,
          page: () => const AdminViewNoticeboard()),
      GetPage(
          name: RoutesGenerator.AdminViewStudentAttendance,
          page: () => const AdminViewStudentAttendance()),
      GetPage(
          name: RoutesGenerator.AdminViewLecturerAttendance,
          page: () => const AdminViewLecturerAttendance()),
      GetPage(
          name: RoutesGenerator.AdminManageScheduleInformation,
          page: () => const AdminManageScheduleInformation()),
      GetPage(
          name: RoutesGenerator.AdminManageTimeSlotInformation,
          page: () => const AdminManageTimeSlotInformation()),


      GetPage(
          name: RoutesGenerator.LecturerViewScheduleView,
          page: () => const LecturerViewScheduleView()),
      GetPage(
          name: RoutesGenerator.LecturerViewHallsView,
          page: () => const LecturerViewHallsView()),
      GetPage(
          name: RoutesGenerator.LecturerManageHallsView,
          page: () => const LecturerManageHallsView()),
      GetPage(
          name: RoutesGenerator.LecturerViewAttendanceView,
          page: () => const LecturerViewAttendanceView()),
      GetPage(
          name: RoutesGenerator.LecturerAddNoticeboardNotes,
          page: () => const LecturerAddNoticeboardNotesView()),
      GetPage(
          name: RoutesGenerator.LecturerScanQRAttendanceView,
          page: () => const LecturerScanQRAttendanceView()),


      GetPage(
          name: RoutesGenerator.ViewStudentAttendanceView,
          page: () => const StudentViewAttendanceView()),


      GetPage(
          name: RoutesGenerator.StudentViewScheduleInformationView,
          page: () => const StudentViewScheduleInformationView()),

      GetPage(
          name: RoutesGenerator.StudentViewNoticeboardView,
          page: () => const StudentViewNoticeboardView()),

      GetPage(
          name: RoutesGenerator.StudentScanQrAttendanceView,
          page: () => const StudentScanQrAttendanceView()),

      GetPage(
          name: RoutesGenerator.StudentViewUniversityMapView,
          page: () => const StudentViewUniversityMapView()),

      GetPage(
          name: RoutesGenerator.home,
          page: () => const Home()),
    ];
  }

  static String initialRoute() => RoutesGenerator.SplashRoute;

}
