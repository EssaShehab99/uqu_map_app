import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';


class StudentNoticeboardRepository extends BaseRepository {

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


}