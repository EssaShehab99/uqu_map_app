import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uqu_map_app/models/schedule.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/admin_manage_schedule_information_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class AdminManageScheduleInformation extends StatelessWidget {
  const AdminManageScheduleInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold(
        "Schedules", AdminManageScheduleInformationBody());
  }
}

class AdminManageScheduleInformationBody extends StatefulWidget {
  const AdminManageScheduleInformationBody({Key? key}) : super(key: key);

  @override
  _AdminManageScheduleInformationBodyState createState() =>
      _AdminManageScheduleInformationBodyState();
}

class _AdminManageScheduleInformationBodyState
    extends State<AdminManageScheduleInformationBody> {
  late AdminManageScheduleInformationViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(adminManageScheduleInformationViewModel.notifier);
    viewModel.getSchedules();
    viewModel.getAllLecturers();
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
              "Lecture name",
              "Start",
              viewModel.lectureNameFieldProvider,
              viewModel.lectureNameFieldProvider),

          const SizedBox(
            height: 14,
          ),

          BasicDateTimeField("Start Date/Time",viewModel.startDateTimeFieldProvider),

          const SizedBox(
            height: 14,
          ),

          BasicDateTimeField("End Date/Time",viewModel.endDateTimeFieldProvider),

          const SizedBox(
            height: 10,
          ),

          Consumer(
            builder: (context, watch, child) {
              AsyncValue usersList = watch(viewModel.getAllLecturerNamesProvider).state;

              return usersList.when(data: (dynamic value) {
                List<User> list = value;
                List<String> lecturerNames = [];

                for(int i=0;i<list.length;i++){
                  lecturerNames.add(list.elementAt(i).userName!);
                }

                return  Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.only(left: 15, right: 0),
                    child: DropDown(
                      items:  lecturerNames,//const ['Reserved', "Free"],
                      hint: const Text(
                        "Select Lecturer",
                        style: TextStyle(color: AppColor.kAccentColorLight),
                      ),
                      icon: const Icon(
                        Icons.expand_more,
                        color: Colors.blue,
                      ),
                      onChanged: (text) {
                        context.read(viewModel.lecturersListFieldProvider).state = list;
                        context.read(viewModel.lecturerNameFieldProvider).state = text.toString();
                      },
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.kAccentColorLight)),
                  ),
                );

              }, error: (Object error, StackTrace? stackTrace) {
                return addScheduleButton(viewModel);
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

          const SizedBox(
            height: 10,
          ),

          Consumer(
            builder: (context, watch, child) {
              AsyncValue addUserState =
                  watch(viewModel.addScheduleStateProvider).state;
              return addUserState.when(data: (dynamic value) {
                return addScheduleButton(viewModel);
              }, error: (Object error, StackTrace? stackTrace) {
                return addScheduleButton(viewModel);
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

          const SizedBox(
            height: 10,
          ),

          Expanded(
            flex: 1,
            child: Consumer(
              builder: (context, watch, child) {
                AsyncValue usersState =
                    watch(viewModel.getScheduleStateProvider).state;
                return usersState.when(data: (dynamic value) {
                  List<Schedule> scheduleList = value;
                  return ListView.builder(
                    itemCount: scheduleList.length,
                    itemBuilder: (context, i) {
                      Schedule schedule = scheduleList[i];
                      return scheduleListCard(schedule);
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
        /* const SizedBox(
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
        ),*/
      ],
    );
  }

  Row dateTextFieldsRow(String field1Label, String field2Label,
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
              // BasicDateTimeField()

/*
              InkWell(
                child: CustomTextField(
                    field1Label, false, false, false, stateProviderField1),

                onTap: () {

                },
              ),
*/
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
              InkWell(
                child: CustomTextField(
                    field2Label, false, false, false, stateProviderField2),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addScheduleButton(AdminManageScheduleInformationViewModel viewModel) {
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
                  child: const Text("Add Schedule"),
                  onPressed: () {
                       viewModel.addSchedule();
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

  Widget addScheduleLocationButton(
      AdminManageScheduleInformationViewModel viewModel) {
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
                  child: const Text("Add Schedule Location"),
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

  Card scheduleListCard(Schedule schedule) {
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
                      'Lecture Name: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${schedule.lectureName}',
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
                      'Start: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${schedule.startDateTime}',
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
                      'End: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${schedule.endDateTime}',
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
                      'Lecturer: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${schedule.lecturerName}',
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
                //  editScheduleButton(schedule),
                  const SizedBox(
                    height: 10,
                  ),
                  deleteButton(schedule),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editScheduleButton(Schedule schedule) {
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
                    context
                        .read(viewModel.updateLectureNameFieldProvider)
                        .state = schedule.lectureName!;
                    context
                        .read(viewModel.updateStartDateTimeFieldProvider)
                        .state = schedule.startDateTime!;
                    context
                        .read(viewModel.updateEndDateTimeFieldProvider)
                        .state = schedule.endDateTime!;

                    showDialog(
                        context: context,
                        builder: (context) =>
                            _onTapUpdateSchedule(schedule)); // Call the Dialog.
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget deleteButton(Schedule schedule) {
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
                    viewModel.delete(schedule);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onTapUpdateSchedule(Schedule schedule) {
    return Scaffold(
      body: WillPopScope(
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
                title: const Text("Update Schedule"),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 0),
                  child: ListView(
                    children: [

                      const SizedBox(height: 10,),
                      textFieldsRow("Lecture name", "", viewModel.updateLectureNameFieldProvider, viewModel.updateLectureNameFieldProvider),
                      const SizedBox(height: 10,),
                      BasicDateTimeField("Start Date/Time",viewModel.updateStartDateTimeFieldProvider),
                      const SizedBox(
                        height: 14,
                      ),
                      BasicDateTimeField("End Date/Time",viewModel.updateEndDateTimeFieldProvider),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: closeButton(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Consumer(
                              builder: (context, watch, child) {
                                AsyncValue scheduleState =
                                    watch(viewModel.updateScheduleStateProvider)
                                        .state;
                                return scheduleState.when(
                                    data: (dynamic value) {
                                  return updateScheduleButton(schedule);
                                }, error:
                                        (Object error, StackTrace? stackTrace) {
                                  return updateScheduleButton(schedule);
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
                          )
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

  SizedBox updateScheduleButton(Schedule schedule) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: const Text("Update Schedule"),
        onPressed: () async {
          viewModel.updateSchedule(schedule,
              isScheduleUpdated: (isScheduleUpdated) {
            if (isScheduleUpdated) {
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
          Navigator.pop(context);
        },
      ),
    );
  }
}

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy HH:mm");

  String title;
  StateProvider stateProvider;
  BasicDateTimeField(this.title,this.stateProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        String updateDateTime = watch(stateProvider).state;
        return  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title),
              DateTimeField(
                format: format,
               // initialValue: (updateDateTime.isEmpty)?DateTime.now(): DateTime.parse(updateDateTime),//DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),//DateTime.parse(updateDateTime)
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {

                    print("Date: ${format.format(date)}");
                    final time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );

                    print("Time: ${time.toString()}");

                    context.read(stateProvider).state = format.format(DateTimeField.combine(date, time)).toString();

                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
            ]);
      },
    );
  }

}
