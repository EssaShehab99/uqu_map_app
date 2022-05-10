import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/admin_view_noticeboard_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class AdminViewNoticeboard extends StatelessWidget {
  const AdminViewNoticeboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Manage Noticeboard",AdminManageNoticeboardBody());
  }
}

class AdminManageNoticeboardBody extends StatefulWidget {
  const AdminManageNoticeboardBody({Key? key}) : super(key: key);

  @override
  _AdminManageNoticeboardBodyState createState() => _AdminManageNoticeboardBodyState();
}

class _AdminManageNoticeboardBodyState extends State<AdminManageNoticeboardBody> {

  late AdminViewNoticeboardViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(adminViewNoticeboardViewModel.notifier);
    viewModel.getNoticeboard();
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
              "Notice Title",
              "Notice Id",
              viewModel.noticeboardTitleFieldProvider,
              viewModel.noticeboardIdFieldProvider),

          const SizedBox(
            height: 10,
          ),

          Container(
            height: 50,
            child: singleBodyTextField(
                "Notice Body",
                viewModel.noticeboardBodyFieldProvider),
          ),

          const SizedBox(
            height: 10,
          ),



          Consumer(
            builder: (context, watch, child) {
              AsyncValue addNoticeboardState =
                  watch(viewModel.addNoticeboardStateProvider).state;
              return addNoticeboardState.when(data: (dynamic value) {
                return addNoticeButton(viewModel);
              }, error: (Object error, StackTrace? stackTrace) {
                return addNoticeButton(viewModel);
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
                    watch(viewModel.getNoticeboardStateProvider).state;
                return usersState.when(data: (dynamic value) {
                  List<Noticeboard> noticeboardList = value;
                  return ListView.builder(
                    itemCount: noticeboardList.length,
                    itemBuilder: (context, i) {
                      Noticeboard noticeboard = noticeboardList[i];
                      return noticeboardListCard(noticeboard);
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

  Widget singleBodyTextField(String field1Label,StateProvider stateProviderField1,){
    var controller = TextEditingController();
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
           // color: Colors.grey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer(
                  builder: (context, watch, child) {
                    var fieldData = watch(stateProviderField1).state;
                    controller.text = fieldData;
                    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                    return Expanded(
                      flex: 1,
                      child: TextField(
                        controller: controller,
                        obscureText: false,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: AppStyles.appTextFieldDecoration(field1Label),
                        onChanged: (text) {
                          context.read(stateProviderField1).state = text;
                        },
                      ),
                    );
                  },
                ),


              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget addNoticeButton(AdminViewNoticeboardViewModel viewModel) {
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
                  child: const Text("Add Notice"),
                  onPressed: () {
                    viewModel.addNoticeboard();
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

  Card noticeboardListCard(Noticeboard noticeboard) {
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
                      'Notice Id: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${noticeboard.noticeboardId}',
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
                      'Notice Title: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${noticeboard.noticeTitle}',
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.normal),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 30,
                    child: Row(children: [
                      Text(
                        'Notice Body: ',
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.bold),
                      ),
                      Text(
                        '${noticeboard.noticeBody}',
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.appSubHeadingTextStyle(
                            AppColor.kAccentColorLight, 12, FontWeight.normal),
                      ),
                    ]),
                  ),

                  const SizedBox(
          height: 10,
        ),
                  (noticeboard.teacherNote != "Empty")? Row(children: [
                    Text(
                      'Teacher Note: ',
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.kAccentColorLight, 12, FontWeight.bold),
                    ),
                    Text(
                      '${noticeboard.teacherNote}',
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
                  editNoticeboardButton(noticeboard),
                  const SizedBox(
                    height: 10,
                  ),
                  deleteButton(noticeboard),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editNoticeboardButton(Noticeboard noticeboard) {
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
                        .read(viewModel.updateNoticeboardIdFieldProvider)
                        .state = noticeboard.id!;

                    context
                        .read(viewModel.updateNoticeboardTitleFieldProvider)
                        .state = noticeboard.noticeTitle!;

                    context
                        .read(viewModel.updateNoticeBodyFieldProvider)
                        .state = noticeboard.noticeBody!;

                    showDialog(
                        context: context,
                        builder: (context) =>
                            _onTapUpdateNoticeboard(noticeboard)); // Call the Dialog.
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget deleteButton(Noticeboard noticeboard) {
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
                    viewModel.delete(noticeboard);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onTapUpdateNoticeboard(Noticeboard noticeboard) {
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
                title: const Text("Update Noticeboard"),
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
                  const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Text('Notice Id: ',
                            style: AppStyles.appSubHeadingTextStyle(
                                AppColor.kAccentColorLight, 12,
                                FontWeight.bold),
                          ),
                          Text('${noticeboard.noticeboardId}',
                            style: AppStyles.appSubHeadingTextStyle(
                                AppColor.kAccentColorLight, 12,
                                FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),


                      const SizedBox(height: 10),
                      AppStyles.textFieldTitleText('Noticeboard Title'),
                      const SizedBox(height: 10),
                      CustomTextField("", false, false, false,
                          viewModel.updateNoticeboardTitleFieldProvider),
                      const SizedBox(height: 20),

                      const SizedBox(height: 10),
                      AppStyles.textFieldTitleText('Noticeboard Body'),
                      const SizedBox(height: 10),
                      CustomTextField("", false, false, false,
                          viewModel.updateNoticeBodyFieldProvider),
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
                                AsyncValue loginState = watch(
                                    viewModel.updateNoticeboardStateProvider)
                                    .state;
                                return loginState.when(data: (dynamic value) {
                                  return updateProfileButton(noticeboard);
                                },
                                    error: (Object error,
                                        StackTrace? stackTrace) {
                                      return updateProfileButton(noticeboard);
                                    },
                                    loading: () {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                              Color>(AppColor.kPrimaryColor),
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

  SizedBox updateProfileButton(Noticeboard noticeboard) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: const Text("Update Noticeboard"),
        onPressed: () async {
          viewModel.updateNoticeboard(
              noticeboard, isNoticeboardUpdated: (isNoticeboardUpdated) {
            if (isNoticeboardUpdated) {
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
