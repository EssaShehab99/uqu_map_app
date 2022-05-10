import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uqu_map_app/themes/app_color.dart';

class AppStyles{

  static TextStyle splashTextStyle() {
    return const TextStyle(color: AppColor.black,fontSize: 20,fontWeight: FontWeight.bold);
  }

  static TextStyle appHeadingTextStyle() {
    return const TextStyle(color: AppColor.black,fontSize: 20,fontWeight: FontWeight.bold,);
  }

  static TextStyle appSubHeadingTextStyle(Color color,double fontSize,FontWeight fontWeight) {
    return  TextStyle(color: color,fontSize: fontSize,fontWeight: fontWeight,);
  }

  static InputDecoration appTextFieldDecoration(String label) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.kPrimaryColor),
      ),
      labelText: "$label",
      labelStyle: const TextStyle(color: AppColor.kAccentColorLight),
      contentPadding: const EdgeInsets.all(15),
    );
  }

  static Widget textFieldTitleText(String text){
    return Text(text,style: TextStyle(color: AppColor.kAccentColorLight,fontSize: 16),);
  }

  static Widget customAppBar(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(title, style: AppStyles.appHeadingTextStyle()),
            ),
          ),
        ],
      ),
    );
  }

  static Widget customScaffold(String appBarTitle,Widget body){
    return Scaffold(
      backgroundColor: AppColor.white,
      resizeToAvoidBottomInset: false,
      // drawer: drawer(viewModel),
      appBar: AppBar(
        backgroundColor: AppColor.appThemeColor,
        title:  Text(appBarTitle),
        centerTitle: true,
        actions: const [],
      ),
      body: SafeArea(child: body),
    );
  }

}