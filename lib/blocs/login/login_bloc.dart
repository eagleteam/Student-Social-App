import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_student_social/blocs/bloc_provider.dart';
import 'package:flutter_student_social/blocs/bloc.dart';
import 'package:flutter_student_social/blocs/login/action.dart';
import 'package:flutter_student_social/support/net.dart';
import 'package:flutter_student_social/support/storage_helper.dart';

class LoginBloc extends BlocBase {
  String _user = 'dtc165d4801030252', _password = 'tbm01031998';

  StreamController _controllerUser = StreamController();

  StreamSink get _inUser => _controllerUser.sink;

  Stream get user => _controllerUser.stream;

  StreamController _controllerPassword = StreamController();

  Stream get password => _controllerPassword.stream;

  StreamSink get _inPassword => _controllerPassword.sink;

  StreamController _controllerAction = StreamController();

  Stream get action => _controllerAction.stream;

  StreamSink get _inAction => _controllerAction.sink;

  Net _net;
  StorageHelper _storageHelper;

  bool profile = false,
      lichhoc = false,
      diem = false,
      lichthi = false,
      lichthilai = true;

  LoginBloc() {
    _net = Net();
    _storageHelper = StorageHelper();
  }

  @override
  void dispose() {
    _controllerUser.close();
    _controllerPassword.close();
    _controllerAction.close();
  }

  void onUserChange(String value) {
    _user = value;
    checkValidUserPassword();
  }

  void onPasswordChange(String value) {
    _password = value;
    checkValidUserPassword();
  }

  void onUserSubmit(String value) {
    if (value.isEmpty) {
      _inUser.addError('Mã sinh viên không được trống');
      return;
    }
    if (value.length < 4) {
      _inUser.addError('Mã sinh viên quá ngắn');
      return;
    }
    _inUser.add(value);
    _inAction.add(Bloc(action: Action.focusToPassword, data: null));
  }

  void onUserEnter() {
    onUserSubmit(_user);
  }

  void onPasswordSubmit(String value) {
    if (value.isEmpty) {
      _inPassword.addError('Mật khẩu không được trống');
      return;
    }
    _inPassword.add(value);
    //
    if (checkValidUserPassword()) {
      //do st
      print('dost');
    }
  }

  void onPasswordEnter() {
    onPasswordSubmit(_password);
  }

  void onPessedLoginButton() {
    _checkInternetConnectivity();
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _inAction.add(
          Bloc(action: Action.showDialog, data: 'Không có kết nối mạng :('));
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      _actionLogin();
    }
  }

  void _actionLogin() {
    _login(_user.toUpperCase(), _password);
    _inAction.add(Bloc(action: Action.showLoading));
  }

  void _login(String user, String password) async {
    var res = await _net.login(user, password);
    var body = res.body.replaceAll("\"", "");
    if (body != 'false') {
      print("Response status: ${res.statusCode}");
//          print("Response body: $a");
      await _storageHelper.saveToken(body);
      _inAction.add(Bloc(action: Action.pop));
      _inAction.add(Bloc(action: Action.showLoading));
      _loadSemester();
    } else {
      _inAction.add(Bloc(action: Action.pop));
      _inAction.add(Bloc(
          action: Action.showDialog,
          data: 'Tài khoản hoặc mật khẩu không chính xác'));
    }
  }

  void _loadSemester() async {
    var res = await _net.loadSemester();
// print("Response body: ${response.body}");
    print("Response status: ${res.statusCode}");
    try {
      var data = json.decode(res.body);
      _inAction.add(Bloc(action: Action.pop));
      _inAction.add(Bloc(action: Action.showDialogChonKy, data: data));
    } catch (e) {
      _inAction.add(Bloc(action: Action.pop));
      _inAction.add(Bloc(action: Action.showDialog, data: e));
    }
  }

  bool checkValidUserPassword() {
    if (_user.length < 4) {
      onUserEnter();
    } else {
      _inUser.add(_user);
    }
    if (_password.isEmpty) {
      onPasswordEnter();
    } else {
      _inPassword.add(_password);
    }
    return _user.length >= 4 && _password.isNotEmpty;
  }

  void onPressedKyHoc(data, kyTruoc) {
    _inAction.add(Bloc(action: Action.pop));
    var _semester = data["MaKy"];
    var _semesterKyTruoc;
//    print(_semester);
    if (kyTruoc != null) {
      _semesterKyTruoc = kyTruoc["MaKy"];
//      print(_semesterKyTruoc);
    }
    _loadData(_semester, _semesterKyTruoc);
  }

  void _loadData(String semester, String semesterKyTruoc) {
    _inAction.add(Bloc(action: Action.showLoading));
    _getLichHoc(semester);
    _getLichThi(semester);
    if (semesterKyTruoc.isNotEmpty) {
      _getLichThiLai(semesterKyTruoc);
    }
    _getDiem();
    _getProfile();
  }

  void _getLichHoc(String semester) async {
    print("maky $semester");
    var res = await _net.loadLichHoc(semester);
    lichhoc = true;
    if (res.statusCode == 200) {
      print('lich hoc=${res.body}');
      await _storageHelper.saveLichHoc(res.body);
      _pushAfterGetDone();
    } else {
      _inAction.add(Bloc(
          action: Action.showDialog,
          data: 'Tải lịch học bị lỗi với code#${res.statusCode}'));
      print(res.body);
    }
  }

  void _getLichThi(String semester) async {
    print("maky $semester");
    var res = await _net.loadLichThi(semester);
    lichthi = true;
    if (res.statusCode == 200) {
      print('lich thi=${res.body}');
      await _storageHelper.saveLichThi(res.body);
      _pushAfterGetDone();
    } else {
      _inAction.add(Bloc(
          action: Action.showDialog,
          data: 'Tải lịch thi bị lỗi với code#${res.statusCode}'));
      print(res.body);
    }
  }

  void _getLichThiLai(String semester) async {
    print("maky $semester");
    var res = await _net.loadLichThi(semester);
    lichthilai = true;
    if (res.statusCode == 200) {
      print('lich thi lai=${res.body}');
      await _storageHelper.saveLichThiLai(res.body);
      _pushAfterGetDone();
    } else {
      _inAction.add(Bloc(
          action: Action.showDialog,
          data: 'Tải lịch thi lại bị lỗi với code#${res.statusCode}'));
      print(res.body);
    }
  }

  void _getDiem() async {
    var res = await _net.getDiem();
    diem = true;
    if (res.statusCode == 200) {
      print("Response body(diem): ${res.body}");
      _storageHelper.writeFile(res.body, Path.Diem);
      _pushAfterGetDone();
    } else {
      _inAction.add(Bloc(
          action: Action.showDialog,
          data: 'Tải điểm bị lỗi với code#${res.statusCode}'));
      print(res.body);
    }
  }

  void _getProfile() async {
    var res = await _net.loadProfile();
    profile = true;
    if (res.statusCode == 200) {
      _storageHelper.writeFile(res.body, Path.profileUser);
      _pushAfterGetDone();
    } else {
      _inAction.add(Bloc(
          action: Action.showDialog,
          data: 'Tải thông tin cá nhân bị lỗi với code#${res.statusCode}'));
      print(res.body);
    }
  }

  void _pushAfterGetDone(){
    if (lichthi && lichhoc && diem && profile && lichthilai) {
      _storageHelper.login().then((file) {
        _inAction.add(Bloc(action: Action.pop));
        _inAction.add(Bloc(action: Action.pop));
        _inAction.add(Bloc(action: Action.push, data: 'MyHomePage'));
      });
    }
  }
}
