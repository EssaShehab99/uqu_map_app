import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/admin_manage_buildings_information_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class AdminManageBuildingsInformation extends StatelessWidget {
  const AdminManageBuildingsInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Manage Buildings",AdminManageBuildingsInformationBody());
  }
}


class AdminManageBuildingsInformationBody extends StatefulWidget {
  const AdminManageBuildingsInformationBody({Key? key}) : super(key: key);

  @override
  State<AdminManageBuildingsInformationBody> createState() => _AdminManageBuildingsInformationBodyState();
}

class _AdminManageBuildingsInformationBodyState extends State<AdminManageBuildingsInformationBody> {
   late AdminManageHallsInformationViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(adminManageBuildingsInformationViewModel.notifier);
    viewModel.getBuildings();
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
              "Building name",
              "Building Id",
              viewModel.buildingNameFieldProvider,
              viewModel.buildingIdFieldProvider),

          const SizedBox(
            height: 10,
          ),

      //    addBuildingLocationButton(viewModel),

          Consumer(
            builder: (context, watch, child) {
              AsyncValue addUserState =
                  watch(viewModel.addBuildingStateProvider).state;
              return addUserState.when(data: (dynamic value) {
                return  addBuildingButton(viewModel);
              }, error: (Object error, StackTrace? stackTrace) {
                return  addBuildingButton(viewModel);
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
                AsyncValue usersState =
                    watch(viewModel.getBuildingsStateProvider).state;
                return usersState.when(data: (dynamic value) {
                  List<Building> buildingList = value;
                  return ListView.builder(
                    itemCount: buildingList.length,
                    itemBuilder: (context, i) {
                      Building building = buildingList[i];
                      return buildingsListCard(building);
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

  Widget addBuildingButton(AdminManageHallsInformationViewModel viewModel) {
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
                  child: const Text("Add Building"),
                  onPressed: () {
                    viewModel.addBuilding();
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

  Widget addBuildingLocationButton(AdminManageHallsInformationViewModel viewModel) {
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
                  child: const Text("Add Building Location"),
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
                   editBuildingButton(building),
                   const SizedBox(
                     height: 10,
                   ),
                   deleteButton(building),
                 ],
               ),
             )
           ],
         ),
       ),
     );
   }

   Widget editBuildingButton(Building building) {
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
                     context.read(viewModel.updateBuildingNameFieldProvider).state = building.buildingName!;
                     context.read(viewModel.updateBuildingIdFieldProvider).state = building.buildingId! ;


                     showDialog(
                         context: context,
                         builder: (context) =>
                             _onTapUpdateBuilding(building)); // Call the Dialog.
                   },
                 ),
               ),
             ),
           ],
         ),
       ],
     );
   }

   Widget deleteButton(Building building) {
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
                     viewModel.delete(building);
                   },
                 ),
               ),
             ),
           ],
         ),
       ],
     );
   }

   _onTapUpdateBuilding(Building building) {
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
                 title: const Text("Update Building"),
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
                       Row(
                         children: [
                           Text('Building Id: ',
                             style: AppStyles.appSubHeadingTextStyle(AppColor.kAccentColorLight,12,FontWeight.bold),
                           ),
                           Text('${building.buildingId}',
                             style: AppStyles.appSubHeadingTextStyle(AppColor.kAccentColorLight,12,FontWeight.bold),
                           )
                                                    ],
                       ),
                       const SizedBox(height: 10),


                       /* CustomTextField(
                           "", false, false, false, viewModel.updateBuildingIdFieldProvider),*/
                       const SizedBox(height: 10),
                       AppStyles.textFieldTitleText('Building Name'),
                       const SizedBox(height: 10),
                       CustomTextField("", false, false, false,
                           viewModel.updateBuildingNameFieldProvider),
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
                                 AsyncValue loginState = watch(viewModel.updateBuildingStateProvider).state;
                                 return loginState.when(data: (dynamic value) {
                                   return updateProfileButton(building);
                                 }, error: (Object error, StackTrace? stackTrace) {
                                   return updateProfileButton(building);
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

   SizedBox updateProfileButton(Building building) {
     return SizedBox(
       height: 50,
       width: 300,
       child: ElevatedButton(
         child: const Text("Update Building"),
         onPressed: () async {
           viewModel.updateBuilding(building,isBuildingUpdated: (isBuildingUpdated) {
             if(isBuildingUpdated){

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
}
