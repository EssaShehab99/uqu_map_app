import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/bulding.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/admin_generate_qr_repository.dart';
import 'package:uqu_map_app/repositories/admin_home_repository.dart';
import 'package:uqu_map_app/repositories/admin_manage_buildings_information_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_add_noticeboard_notes_repository.dart';
import 'package:uqu_map_app/repositories/lecturer_scan_qr_attendance_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final lecturerAddNoticeboardNotesViewModel =
StateNotifierProvider<LecturerAddNoticeboardNotesViewModel, Map<String, dynamic>>(
        (ref) => LecturerAddNoticeboardNotesViewModel(ref));

class LecturerAddNoticeboardNotesViewModel extends BaseViewModel<Map<String, dynamic>> {

  LecturerAddNoticeboardNotesViewModel(this.ref,) : super({});
  ProviderReference ref;

  final LecturerAddNoticeboardNotesRepository _repository = LecturerAddNoticeboardNotesRepository();

  final getNoticeboardStateProvider =
  StateProvider<AsyncValue<List<Noticeboard>>>((ref) => AsyncLoading());

  final addNoticeboardNoteFieldProvider = StateProvider<String>((ref) => "");

  final updateNoticeboardStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));


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

  updateNoticeboard(Noticeboard noticeboard,{required Function(bool isNoticeboardUpdated) isNoticeboardUpdated}) async {
    ref.read(updateNoticeboardStateProvider)
        .state = const AsyncLoading();

    var noticeboardNote = ref.read(addNoticeboardNoteFieldProvider).state;

    if(validateNoticeboard()){
      _repository.updateNoticeboard(noticeboard,noticeboardNote,
        onSuccess: (noticeboard) {
          ref.read(addNoticeboardNoteFieldProvider).state = '';
          ref.read(updateNoticeboardStateProvider).state = const AsyncData(0);
          showSnackBar("Note Added ", Colors.blue);
          isNoticeboardUpdated(true);
          getNoticeboard();
        },
        onFailed: (error) {
          ref.read(updateNoticeboardStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          isNoticeboardUpdated(false);
        },
      );

      /*_repository.updateNoticeboard(noticeboard,noticeboard.noticeboardId!, noticeboardTitle,noticeboardBody,
        onSuccess: (noticeboard) {
          ref.read(updateNoticeboardIdFieldProvider).state = '';
          ref.read(updateNoticeboardTitleFieldProvider).state = '';
          ref.read(updateNoticeBodyFieldProvider).state = '';
          ref.read(updateNoticeboardStateProvider).state = const AsyncData(0);

          showSnackBar("Noticeboard successfully updated", Colors.red);
          isNoticeboardUpdated(true);
          getNoticeboard();
        },
        onFailed: (error) {
          ref.read(updateNoticeboardStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          isNoticeboardUpdated(false);
        },
      );

       */
    }else{
      ref.read(updateNoticeboardStateProvider).state = AsyncData(0);
    }

  }


  bool validateNoticeboard() {
    var noticeboardNote = ref.read(addNoticeboardNoteFieldProvider).state;

    if (noticeboardNote.isEmpty) {
      showSnackBar("Error: Please enter note", Colors.red);
      return false;
    } else {
      return true;
    }
  }

}