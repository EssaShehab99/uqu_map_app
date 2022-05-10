import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/view_models/student_view_university_map_view_model.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

import '../../../themes/app_color.dart';
import '../../login_screen/login_view.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(child: MapViewScreenBody()),
    );
  }
}

class MapViewScreenBody extends StatefulWidget {
  const MapViewScreenBody({Key? key}) : super(key: key);

  @override
  _MapViewScreenBodyState createState() => _MapViewScreenBodyState();
}

class _MapViewScreenBodyState extends State<MapViewScreenBody> {
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

        return buildings.when(
            data: (dynamic value) {
          List<Building> buildings = value;
          List<Marker> markers = [];

          if (buildings.elementAt(0).lat != null) {
           // double initLat = double.parse(buildings.elementAt(0).lat!);
           // double initLng = double.parse(buildings.elementAt(0).lang!);

            print(
                'LatLang ${buildings.elementAt(0).lat!},${buildings.elementAt(0).lang!}');

            MapOptions mapOptions = MapOptions(
              center: LatLng(21.65146698239675, 39.715992090405145),//initLat, initLng),
              zoom: 19,
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
                      showDialog(
                          context: context,
                          builder: (context) =>
                              _onTapUpdateSchedule(buildings[i]));
                    },
                    child: Container(
                      child:
                      (i==0)? ImageIcon(AssetImage("assets/images/green.png"), size: 40.0,color: Colors.green):
                      (i==1)?ImageIcon(AssetImage("assets/images/red.png"), size: 40.0,color: Colors.red):
                      (i==2)?ImageIcon(AssetImage("assets/images/yellow.png"), size: 40.0,color: Colors.yellow):
                      (i==3)?ImageIcon(AssetImage("assets/images/green.png"), size: 40.0,color: Colors.green):
                      ImageIcon(AssetImage("assets/images/red.png"), size: 40.0,color: Colors.red),
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

  _onTapUpdateSchedule(Building building) {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: buildingsListCard(building),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 0),
                    child: ListView(children: [
                      Row(children: [
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 30,
                              width: 300,
                              child: ElevatedButton(
                                  child: const Text("Login"),
                                  onPressed: () {
                                    Get.offAll(const LoginView());
                                  }),
                            ))
                      ])
                    ])))
          ],
        ),
      ),
    );
  }

  Card buildingsListCard(Building building) {
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
                      'Building Id: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${building.buildingId}',
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
                      'Name: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${building.buildingName}',
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
                      'Latitude: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${building.lat!.substring(0, 6)}',
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
                      'Longitude: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${building.lang!.substring(0, 6)}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.normal),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
