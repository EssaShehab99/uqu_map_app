import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_add_noticeboard_notes_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_scan_qr_attendance_repository.dart';
import 'package:uqu_map_app/repositories/student_view_noticeboard_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final studentViewNoticeboardViewModel =
StateNotifierProvider<StudentViewNoticeboardViewModel, Map<String, dynamic>>(
        (ref) => StudentViewNoticeboardViewModel(ref));

class StudentViewNoticeboardViewModel extends BaseViewModel<Map<String, dynamic>> {

  StudentViewNoticeboardViewModel(this.ref,) : super({});
  ProviderReference ref;

  final StudentNoticeboardRepository _repository = StudentNoticeboardRepository();

  final getNoticeboardStateProvider =
  StateProvider<AsyncValue<List<Noticeboard>>>((ref) => AsyncLoading());

  getNoticeboard(){
    _repository.getAllNoticeboards(
      onSuccess: (noticeboards) {
        ref.read(getNoticeboardStateProvider).state = AsyncData(noticeboards);

      },
      onFailed: (error) {
        ref.read(getNoticeboardStateProvider).state = AsyncError(3);
        //  showSnackBar("Error: $error", Colors.red);
      },
    );
  }
}