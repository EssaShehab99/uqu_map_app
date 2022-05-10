
import 'package:flutter/material.dart';
import 'package:uqu_map_app/models/noticeboard.dart';
import 'package:uqu_map_app/repositories/admin_view_noticeboard_repository.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminViewNoticeboardViewModel =
StateNotifierProvider<AdminViewNoticeboardViewModel, Map<String, dynamic>>(
        (ref) => AdminViewNoticeboardViewModel(ref));

class AdminViewNoticeboardViewModel extends BaseViewModel<Map<String, dynamic>> {

  AdminViewNoticeboardViewModel(this.ref,) : super({});
  ProviderReference ref;

  final AdminViewNoticeboardRepository _repository = AdminViewNoticeboardRepository();

  final noticeboardIdFieldProvider = StateProvider<String>((ref) => "");
  final updateNoticeboardIdFieldProvider = StateProvider<String>((ref) => "");

  final noticeboardTitleFieldProvider = StateProvider<String>((ref) => "");
  final updateNoticeboardTitleFieldProvider = StateProvider<String>((ref) => "");

  final noticeboardBodyFieldProvider = StateProvider<String>((ref) => "");
  final updateNoticeBodyFieldProvider = StateProvider<String>((ref) => "");

  final addNoticeboardStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

  final updateNoticeboardStateProvider =
  StateProvider<AsyncValue<int>>((ref) => AsyncData(0));

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

  addNoticeboard(){
    var noticeboardId = ref.read(noticeboardIdFieldProvider).state;
    var noticeboardTitle = ref.read(noticeboardTitleFieldProvider).state;
    var noticeboardBody = ref.read(noticeboardBodyFieldProvider).state;

    ref.read(addNoticeboardStateProvider).state = AsyncLoading();
    if(validateNoticeboardData()){
      _repository.addNoticeboard(
        noticeboardId,
        noticeboardTitle,
        noticeboardBody,
        onSuccess: (user) {
          ref.read(addNoticeboardStateProvider).state = AsyncData(0);
          showSnackBar("Noticeboard successfully added", Colors.red);
          ref.read(noticeboardIdFieldProvider).state = '';
          ref.read(noticeboardTitleFieldProvider).state = '';
          ref.read(noticeboardBodyFieldProvider).state = '';
          getNoticeboard();
        },
        onFailed: (error) {
          ref.read(addNoticeboardStateProvider).state = AsyncError(3);
          showSnackBar("Error: $error", Colors.red);
          getNoticeboard();
        },
      );
    }else{
      ref.read(addNoticeboardStateProvider).state = AsyncData(0);
    }

  }

  delete(Noticeboard noticeboard) async {
    ref.read(getNoticeboardStateProvider).state = AsyncLoading();
    _repository.deleteNoticeboard(
      noticeboard,
      onSuccess: (noticeboard) {
        showSnackBar("Noticeboard deleted", Colors.red);
        getNoticeboard();
      },
      onFailed: (error) {
        getNoticeboard();
        showSnackBar("Error: $error", Colors.red);
      },
    );
  }

  bool validateNoticeboardData() {
    var noticeboardId = ref.read(noticeboardIdFieldProvider).state;
    var noticeboardTitle = ref.read(noticeboardTitleFieldProvider).state;
    var noticeboardBody = ref.read(noticeboardBodyFieldProvider).state;


    if (noticeboardId.isEmpty) {
      showSnackBar("Error: Please enter noticeboard id", Colors.red);
      return false;
    } else if (noticeboardTitle.isEmpty) {
      showSnackBar("Error: Please enter noticeboard title", Colors.red);
      return false;
    } else if (noticeboardBody.isEmpty) {
      showSnackBar("Error: Please enter noticeboard body", Colors.red);
      return false;
    } else {
      return true;
    }
  }

  bool validateUpdateNoticeboard() {
    var noticeboardId = ref.read(updateNoticeboardIdFieldProvider).state;
    var noticeboardTitle = ref.read(updateNoticeboardTitleFieldProvider).state;
    var noticeboardBody = ref.read(updateNoticeBodyFieldProvider).state;

    if (noticeboardTitle.isEmpty) {
      showSnackBar("Error: Please enter noticeboard title", Colors.red);
      return false;
    } else if (noticeboardBody.isEmpty) {
      showSnackBar("Error: Please enter noticeboard body", Colors.red);
      return false;
    } else {
      return true;
    }
  }

  updateNoticeboard(Noticeboard noticeboard,{required Function(bool isNoticeboardUpdated) isNoticeboardUpdated}) async {
    ref.read(updateNoticeboardStateProvider)
        .state = const AsyncLoading();

    var noticeboardId = ref.read(updateNoticeboardIdFieldProvider).state;
    var noticeboardTitle = ref.read(updateNoticeboardTitleFieldProvider).state;
    var noticeboardBody = ref.read(updateNoticeBodyFieldProvider).state;

    if(validateUpdateNoticeboard()){
      _repository.updateNoticeboard(noticeboard,noticeboard.noticeboardId!, noticeboardTitle,noticeboardBody,
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
    }else{
      ref.read(updateNoticeboardStateProvider).state = AsyncData(0);
    }

  }

}
