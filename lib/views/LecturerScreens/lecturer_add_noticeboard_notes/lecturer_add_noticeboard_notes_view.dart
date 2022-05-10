import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/lecturer_add_noticeboard_notes_view_model.dart';
import 'package:uqu_map_app/views/custom_widgets/CustomTextField.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class LecturerAddNoticeboardNotesView extends StatelessWidget {
  const LecturerAddNoticeboardNotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Noticeboard",LecturerAddNoticeboardNotesViewBody());
  }
}

class LecturerAddNoticeboardNotesViewBody extends StatefulWidget {
  const LecturerAddNoticeboardNotesViewBody({Key? key}) : super(key: key);

  @override
  _LecturerAddNoticeboardNotesViewBodyState createState() => _LecturerAddNoticeboardNotesViewBodyState();
}

class _LecturerAddNoticeboardNotesViewBodyState extends State<LecturerAddNoticeboardNotesViewBody> {

  late LecturerAddNoticeboardNotesViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(lecturerAddNoticeboardNotesViewModel.notifier);
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
                  addNoteButton(noticeboard),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addNoteButton(Noticeboard noticeboard) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 30,
                child: ElevatedButton(
                  child: Text("Add Note",
                      style: AppStyles.appSubHeadingTextStyle(
                          AppColor.white, 12, FontWeight.bold)),
                  onPressed: () {

                    showDialog(
                        context: context,
                        builder: (context) =>
                            _onTapUpdateNoticeboard(noticeboard)); // Call the Dialog.

                  /*  context
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


                   */
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
                title: const Text("Add Note"),
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
                      AppStyles.textFieldTitleText('Note:'),
                      const SizedBox(height: 10),
                      CustomTextField("", false, false, false, viewModel.addNoticeboardNoteFieldProvider),
                      const SizedBox(height: 20),
                      Row(
                        children: [
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
        child: const Text("Add Note"),
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

}
