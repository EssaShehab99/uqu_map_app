import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/lecturer_manage_halls_view_model.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class LecturerManageHallsView extends StatelessWidget {
  const LecturerManageHallsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Manage Halls",LecturerManageHallsViewBody());
  }
}

class LecturerManageHallsViewBody extends StatefulWidget {
  const LecturerManageHallsViewBody({Key? key}) : super(key: key);

  @override
  _LecturerManageHallsViewBodyState createState() => _LecturerManageHallsViewBodyState();
}

class _LecturerManageHallsViewBodyState extends State<LecturerManageHallsViewBody> {

  late LecturerManageHallsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(lecturerManageHallsViewModel.notifier);
    viewModel.getHalls();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Expanded(
            flex: 1,
            child: Consumer(
              builder: (context, watch, child) {
                AsyncValue hallState =
                    watch(viewModel.getHallStateProvider).state;
                return hallState.when(data: (dynamic value) {
                  List<Hall> hallList = value;
                  return ListView.builder(
                    itemCount: hallList.length,
                    itemBuilder: (context, i) {
                      Hall hall = hallList[i];
                      return hallListCard(hall);
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

  Card hallListCard(Hall hall) {
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
                      'Hall Id: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${hall.hallId}',
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
                      'Hall Name: ',
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
                      'Free Seats: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${hall.freeSeats}',
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
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  (hall.reservedByUserName != null)?Row(children: [
                    Text(
                      'Reserved By: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${hall.reservedByUserName}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.normal),
                    ),
                  ]):Container()
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
                  (hall.status == "Free")? reserveButton(hall) : cancelReservation(hall)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget reserveButton(Hall hall) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  child: Text("Reserve",
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.white, 12, FontWeight.bold)),
                  onPressed: () {
                    viewModel.reserveHall(hall);
                    //Reserve button
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cancelReservation(Hall hall) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: Text("Cancel Reservation",textAlign: TextAlign.center,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.white, 10, FontWeight.bold)),
                  onPressed: () {
                    viewModel.cancelReservationHall(hall);
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



