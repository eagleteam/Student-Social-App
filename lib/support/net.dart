import 'dart:async';

import 'package:flutter_student_social/support/link.dart';
import 'package:flutter_student_social/support/storage_helper.dart';
import 'package:http/http.dart' as http;

class Net {
  StorageHelper _storageHelper;

  Net() {
    _storageHelper = StorageHelper();
  }

  Future<http.Response> getDiem() async {
    return http.post(Link.getDiem,
        headers: {"access-token": await _storageHelper.loadToken()});
  }

  Future<http.Response> login(String user, password) async {
    return http
        .post(Link.login, body: {"username": user, "password": password});
  }

  Future<http.Response> loadSemester() async {
    return http.post(Link.getSemester,
        headers: {"access-token": await _storageHelper.loadToken()});
  }

  Future<http.Response> loadLichHoc(String semester) async {
    return http.post(Link.getLichHoc,
        headers: {"access-token": await _storageHelper.loadToken()},
        body: {"semester": semester});
  }

  Future<http.Response> loadLichThi(String semester) async {
    return http.post(Link.getLichThi,
        headers: {"access-token": await _storageHelper.loadToken()},
        body: {"semester": semester});
  }

  Future<http.Response> loadProfile() async {
    return http.post(Link.getProfile,
        headers: {"access-token": await _storageHelper.loadToken()});
  }
}
