import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/hall.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/admin_manage_buildings_information_view_model.dart';
import 'package:uqu_map_app/view_models/admin_manage_hall_information_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class AdminManageHallInformation extends StatelessWidget {
  const AdminManageHallInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Manage Halls",AdminManageHallInformationBody());
  }

}


class AdminManageHallInformationBody extends StatefulWidget {
  const AdminManageHallInformationBody({Key? key}) : super(key: key);



  @override
  State<AdminManageHallInformationBody> createState() => _AdminManageHallInformationBodyState();
}

class _AdminManageHallInformationBodyState extends State<AdminManageHallInformationBody> {

  late AdminManageHallInformationViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(adminManageHallInformationViewModel.notifier);
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

          const SizedBox(
            height: 5,
          ),

          textFieldsRow(
              "Hall name",
              "Hall Id",
              viewModel.hallNameFieldProvider,
              viewModel.hallIdFieldProvider),

          const SizedBox(
            height: 10,
          ),

          textFieldAndDropDown(
            context,
              "Capacity",
              "",
              viewModel.hallCapacityFieldProvider,
              viewModel.hallReservationStatusFieldProvider),

          const SizedBox(
            height: 10,
          ),

          Container(
            width: 200,
            child: Row(
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
                          "Free Seats", false, false, false, viewModel.hallFreeSeatsFieldProvider),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Consumer(
            builder: (context, watch, child) {
              AsyncValue addUserState =
                  watch(viewModel.addHallStateProvider).state;
             return addUserState.when(data: (dynamic value) {
                return  addHallButton(viewModel);
              }, error: (Object error, StackTrace? stackTrace) {
                return  addHallButton(viewModel);
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



          const SizedBox(
            height: 10,
          ),

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

  Widget addHallButton(AdminManageHallInformationViewModel viewModel) {
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
                  child: const Text("Add Hall"),
                  onPressed: () {
                    viewModel.addHall();
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

  Widget addHallLocationButton(AdminManageHallsInformationViewModel viewModel) {
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
                  child: const Text("Add Hall Location"),
                  onPressed: () {
                    //viewModel.addUserUsers();
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
                  editHallButton(hall),
                  const SizedBox(
                    height: 10,
                  ),
                  deleteButton(hall),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editHallButton(Hall hall) {
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
                    context.read(viewModel.updateHallNameFieldProvider).state = hall.hallName!;
                    context.read(viewModel.updateHallIdFieldProvider).state = hall.hallId! ;
                    context.read(viewModel.updateCapacityFieldProvider).state = hall.capacity.toString();
                    context.read(viewModel.updateFreeSeatsFieldProvider).state = hall.freeSeats.toString();
                    context.read(viewModel.updateHallReservationStatusFieldProvider).state = hall.status! ;

                    showDialog(
                        context: context,
                        builder: (context) =>
                            _onTapUpdateHall(hall)); // Call the Dialog.
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget deleteButton(Hall hall) {
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
                    viewModel.delete(hall);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onTapUpdateHall(Hall hall) {
    return Scaffold(
      body : WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBar(
                backgroundColor: AppColor.appThemeColor,
                title: const Text("Update Hall"),
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
                child: Container(
                  padding:
                  const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Hall Id: ',
                            style: AppStyles.appSubHeadingTextStyle(AppColor.kAccentColorLight,16,FontWeight.bold),
                          ),
                          Text('${hall.hallId}',
                            style: AppStyles.appSubHeadingTextStyle(AppColor.kAccentColorLight,16,FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      AppStyles.textFieldTitleText('Hall Name'),

                      const SizedBox(height: 10),
                      CustomTextField("", false, false, false,
                          viewModel.updateHallNameFieldProvider),

                      const SizedBox(height: 20),
                      AppStyles.textFieldTitleText('Hall Capacity'),
                      const SizedBox(height: 20),
                      textFieldAndDropDownUpdateScreen(context, "Hall Capacity", "", viewModel.updateCapacityFieldProvider,viewModel.updateHallReservationStatusFieldProvider),
                      const SizedBox(height: 20),
                      Container(
                        width: 200,
                        child: Row(
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
                                      "Free Seats", false, false, false, viewModel.updateFreeSeatsFieldProvider),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

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
                                AsyncValue updateHallState = watch(viewModel.updateHallStateProvider).state;
                                return updateHallState.when(data: (dynamic value) {
                                  return updateProfileButton(hall);
                                }, error: (Object error, StackTrace? stackTrace) {
                                  return updateProfileButton(hall);
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

  SizedBox updateProfileButton(Hall hall) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: const Text("Update Hall"),
        onPressed: () async {
          viewModel.updateHall(hall,isHallUpdated: (isHallUpdated) {
            if(isHallUpdated){

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
          /*    context.read(viewModel.updateFirstNameFieldProvider).state = '';
           context.read(viewModel.updateLastNameFieldProvider).state = '';
           context.read(viewModel.updateEmailFieldProvider).state = '';
           context.read(viewModel.updatePasswordFieldProvider).state = '';*/
          Navigator.pop(context);
        },
      ),
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
                padding: const EdgeInsets.only(left: 15, right: 0),
                child: DropDown(
                  items:  const ['Reserved', "Free"],
                  hint: const Text(
                    "Select Status",
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

  Row textFieldAndDropDownUpdateScreen(
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
                padding: const EdgeInsets.only(left: 15, right: 0),
                child: DropDown(
                  items:  const ['Reserved', "Free"],
                  hint: const Text(
                    "Select Status",
                    style: TextStyle(color: AppColor.kAccentColorLight),
                  ),
                  icon: const Icon(
                    Icons.expand_more,
                    color: Colors.blue,
                  ),
                  initialValue: context.read(stateProviderField2).state,
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
}
