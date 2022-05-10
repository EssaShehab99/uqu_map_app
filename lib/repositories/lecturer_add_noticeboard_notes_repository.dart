import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';

import '../models/user.dart';


class LecturerAddNoticeboardNotesRepository extends BaseRepository {

  getAllNoticeboards(
      {required Function(List<Noticeboard> noticeboard) onSuccess,
        required Function(String error) onFailed}) {

    FirebaseFirestore.instance
        .collection(Strings.noticeboardCollection)
        .get()
        .then((value) {
      if ((value.size > 0)) {
        List<Noticeboard> noticeboardList = [];

        for (var element in value.docs) {
          Noticeboard noticeboard = Noticeboard.fromJson(element.data());
          noticeboardList.add(noticeboard);
        }

        onSuccess(noticeboardList);
      }else{
        onFailed("No Noticeboard found");
      }
    });
  }

Future<void> updateNoticeboard(
      Noticeboard currentNoticeboard,
      String teacherNote,
      {required Function(Noticeboard noticeboard) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    DocumentReference collection =
    fireStore.collection(Strings.noticeboardCollection).doc(currentNoticeboard.noticeboardId);
    Noticeboard noticeboard = Noticeboard();
    noticeboard.id = currentNoticeboard.id;
    noticeboard.noticeboardId = currentNoticeboard.noticeboardId;
    noticeboard.noticeTitle = currentNoticeboard.noticeTitle;
    noticeboard.noticeBody = currentNoticeboard.noticeBody;
    noticeboard.teacherNote = teacherNote;
    noticeboard.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
    noticeboard.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";

    collection.set(noticeboard.toJson()).then((value) {
      onSuccess(noticeboard);
      print("Noticeboard update success");
    }).catchError((error) {
      onFailed("Failed to update");
      print("Failed to update noticeboard: $error");
    });

  }
}