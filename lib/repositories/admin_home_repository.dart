import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uqu_map_app/config/Strings.dart';
import 'package:uqu_map_app/models/user.dart';
import 'package:uqu_map_app/repositories/base_respository.dart';

class AdminHomeRepository extends BaseRepository {
  Future<User?> getLoggedUser() async {
    return await getUser();
  }



}
