
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class BaseViewModel<T> extends StateNotifier<T> {
  BaseViewModel(T state) : super(state);

  void showSnackBar(String message, Color color, {String? title}) =>
      Get.rawSnackbar(
        title: title,
        message: message,
        margin: const EdgeInsets.all(20),
        borderRadius: 25,
        backgroundColor: color,
        snackPosition: SnackPosition.BOTTOM,
      );
}
