import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'package:uqu_map_app/view_models/lecturer_add_noticeboard_notes_view_model.dart';
import 'package:uqu_map_app/view_models/student_view_noticeboard_view_model.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';
class StudentViewNoticeboardView extends StatelessWidget {
  const StudentViewNoticeboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStyles.customScaffold("Noticeboard",StudentViewNoticeboardViewBody());
  }
}

class StudentViewNoticeboardViewBody extends StatefulWidget {
  const StudentViewNoticeboardViewBody({Key? key}) : super(key: key);

  @override
  _StudentViewNoticeboardViewBodyState createState() => _StudentViewNoticeboardViewBodyState();
}

class _StudentViewNoticeboardViewBodyState extends State<StudentViewNoticeboardViewBody> {

  late StudentViewNoticeboardViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read(studentViewNoticeboardViewModel.notifier);
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


                ],
              ),
            ),
            /* SizedBox(
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
            )*/
          ],
        ),
      ),
    );
  }
}
