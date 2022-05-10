import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/view_models/student_view_university_map_view_model.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';
import 'package:flutter/foundation.dart';
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
import 'package:uqu_map_app/views/login_screen/login_view.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';
import 'package:latlong2/latlong.dart';

class StudentViewUniversityMapView extends StatelessWidget {
  const StudentViewUniversityMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("University Map",StudentViewUniversityMapViewBody());
  }
}

class StudentViewUniversityMapViewBody extends StatefulWidget {
  const StudentViewUniversityMapViewBody({Key? key}) : super(key: key);

  @override
  _StudentViewUniversityMapViewBodyState createState() => _StudentViewUniversityMapViewBodyState();
}

class _StudentViewUniversityMapViewBodyState extends State<StudentViewUniversityMapViewBody> {

  LatLng? latLng = LatLng(51.5, -0.09);

  late StudentViewUniversityViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(studentViewUniversityViewModel.notifier);
    viewModel.getBuildings();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        AsyncValue buildings = watch(viewModel.getBuildingsStateProvider).state;

        return buildings.when(data: (dynamic value) {
          List<Building> buildings = value;
          List<Marker> markers = [];

          if (buildings.elementAt(0).lat != null) {
            double initLat = double.parse(buildings.elementAt(0).lat!);
            double initLng = double.parse(buildings.elementAt(0).lang!);

            print(
                'LatLang ${buildings.elementAt(0).lat!},${buildings.elementAt(0).lang!}');

            MapOptions mapOptions = MapOptions(
              center: LatLng(initLat, initLng),
              zoom: 16.0,
            );
            for (int i = 0; i < buildings.length; i++) {
              if (buildings.elementAt(i).lat != null) {
                double lat = double.parse(buildings.elementAt(i).lat!);
                double lng = double.parse(buildings.elementAt(i).lang!);
                Marker marker = Marker(
                  width: 50.0,
                  height: 50.0,
                  point: LatLng(lat, lng),
                  builder: (ctx) => InkWell(
                    onTap: () {
                     /* showDialog(
                          context: context,
                          builder: (context) =>
                             _onTapUpdateSchedule(buildings[i]));*/
                    },
                    child: Container(
                      child:
                      Icon(Icons.pin_drop, color: Colors.red, size: 50.0),
                    ),
                  ),
                );
                markers.add(marker);
              }
            }

            return FlutterMap(
              options: mapOptions,
              layers: [

                TileLayerOptions(
                  tileProvider: NetworkTileProvider(),
                  urlTemplate: 'http://mt{s}.google.com/vt/lyrs=m@221097413,parking,traffic,lyrs=m&x={x}&y={y}&z={z}',
                  subdomains: ['0', '1', '2', '3'],
                  retinaMode: true,
                  maxZoom: 20,
                ),


                MarkerLayerOptions(
                  markers: markers,
                )

                /*TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: markers,
              ),*/
              ],
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: const Text("No building found")),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: ElevatedButton(
                      child: const Text("Login"),
                      onPressed: () {
                        Get.offAll(const LoginView());
                      }),
                )
              ],
            );
          }
        }, error: (Object error, StackTrace? stackTrace) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: const Text("No building found")),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                    child: const Text("Login"),
                    onPressed: () {
                      Get.offAll(const LoginView());
                    }),
              )
            ],
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.kPrimaryColor),
            ),
          );
        });
      },
    );


  }
}
