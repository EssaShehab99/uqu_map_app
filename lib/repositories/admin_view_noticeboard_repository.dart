import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';
import 'package:uuid/uuid.dart';

class AdminViewNoticeboardRepository extends BaseRepository {

  void addNoticeboard(
      String noticeboardId,
      String noticeTitle,
      String noticeBody,
      {required Function(Noticeboard noticeboard) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    FirebaseFirestore.instance
        .collection(Strings.noticeboardCollection)
        .doc(noticeboardId)
        .get()
        .then((value) async {

      if (value.data() == null) {

        DocumentReference collection =
        fireStore.collection(Strings.noticeboardCollection).doc(noticeboardId);

        Noticeboard noticeboard = Noticeboard();
        noticeboard.id = Uuid().v5(Uuid.NAMESPACE_URL, noticeboardId);
        noticeboard.noticeboardId = noticeboardId;
        noticeboard.noticeTitle = noticeTitle;
        noticeboard.noticeBody = noticeBody;
        noticeboard.teacherNote = "Empty";
        noticeboard.addByAdminId = (loggedUser != null) ? loggedUser.id : "null";
        noticeboard.addByAdminUserName = (loggedUser != null) ? loggedUser.userName : "null";

        collection.set(noticeboard.toJson()).then((value) {
          print("Noticeboard Added");
          onSuccess(noticeboard);
        }).catchError((error) {
          print("Failed to add noticeboard: $error");
          onFailed("Unable to add noticeboard");
        });
      } else {
        onFailed("Noticeboard id already exist");
      }
    });

  }

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

  deleteNoticeboard(
      Noticeboard noticeboard,
      {required Function(User user) onSuccess,
        required Function(String error) onFailed}) {
    FirebaseFirestore.instance
        .collection(Strings.noticeboardCollection)
        .doc(noticeboard.noticeboardId).delete().then((value){
      print("Noticeboard deleted");
      onSuccess(User());
    }).catchError((error) {
      print("Failed to delete noticeboard: $error");
      onFailed("Unable to delete");
    });
  }

  Future<void> updateNoticeboard(
      Noticeboard currentNoticeboard,
      String noticeboardId,
      String noticeTitle,
      String noticeBody,
      {required Function(Noticeboard noticeboard) onSuccess,
        required Function(String error) onFailed}) async {

    User? loggedUser = await getUser();

    DocumentReference collection =
    fireStore.collection(Strings.noticeboardCollection).doc(currentNoticeboard.noticeboardId);
    Noticeboard noticeboard = Noticeboard();
    noticeboard.id = currentNoticeboard.id;
    noticeboard.noticeboardId = noticeboardId;
    noticeboard.noticeTitle = noticeTitle;
    noticeboard.noticeBody = noticeBody;
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