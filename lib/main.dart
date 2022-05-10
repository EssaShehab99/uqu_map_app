import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uqu_map_app/config/AppRouter.dart';
import 'package:uqu_map_app/data/SharedPreferencesService.dart';
import 'package:uqu_map_app/themes/app_color.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(SharedPreferencesService());
  runApp(const ProviderScope(child: App()));
}


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.appThemeColor,
      statusBarBrightness: Brightness.dark,
    ));

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UQU Map',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRouter.initialRoute(),
        getPages: AppRouter.router(),
    );
  }
}





