import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_social/support/color_loader.dart';
import 'package:flutter_student_social/support/dot_type.dart';
import 'package:flutter_student_social/support/storage_helper.dart';
import 'package:flutter_student_social/support/url.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static final String tag = 'login-page';
  static String alive = 'false';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  String _semester = '', _semesterKyTruoc = '', _token;
  bool profile = false,
      lichhoc = false,
      diem = false,
      lichthi = false,
      lichthilai = true;
  StorageHelper storageHelper;

  @override
  void initState() {
    super.initState();
    storageHelper = StorageHelper();
  }

  _actionLogin() {
    if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
      alert("Bạn không được để trống tài khoản mật khẩu");
    } else {
      _signIn(_controllerEmail.text.toUpperCase(), _controllerPassword.text);
      _dialogLogin("Đang đăng nhập");
    }
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      alert('Không có kết nối mạng :(');
    } else if (result == ConnectivityResult.mobile) {
      _actionLogin();
    } else if (result == ConnectivityResult.wifi) {
      _actionLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 80,
      backgroundImage: AssetImage('image/Logo.png'),
    );
    FocusNode textSecondFocusNode = FocusNode();

    final email = TextField(
      controller: _controllerEmail,
      autofocus: true,
      textCapitalization: TextCapitalization.characters,
      onSubmitted: (value) {
        FocusScope.of(context).requestFocus(textSecondFocusNode);
      },
      decoration: InputDecoration(
        hintText: 'Mã sinh viên',
        labelText: 'Mã sinh viên',
        prefixIcon: Icon(Icons.account_circle),
        suffixIcon: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              FocusScope.of(context).requestFocus(textSecondFocusNode);
            }),
        contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );

    final password = TextField(
      focusNode: textSecondFocusNode,
      controller: _controllerPassword,
      obscureText: true,
      onSubmitted: (value) {
        _checkInternetConnectivity();
      },
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _checkInternetConnectivity();
            }),
        contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );

    final loginButton = Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.all(0),
      child: RaisedButton(
        child: Text('ĐĂNG NHẬP', style: TextStyle(color: Colors.white)),
        onPressed: () {
          _checkInternetConnectivity();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.green,
      ),
    );

    Future<bool> _canLeave(BuildContext context) {
//      if (LoginPage1.alive == 'true') {
//        return new Future<bool>.value(true);
//      } else
//        return _prompt(context);
      return Future<bool>.value(false);
    }

    return Scaffold(
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logo,
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                  ),
                  Text(
                    'Student Social',
                    style: TextStyle(color: Colors.black, fontSize: 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                  ),
                  email,
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                  ),
                  password,
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                  ),
                  loginButton,
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => _canLeave(context),
      ),
    );
  }

  Future<void> _dialogLogin(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator()
        );
      },
    );
  }

  void _signIn(String email, String password) {
    var url = URL.login;
    http.post(url, body: {"username": email, "password": password}).then(
        (response) {
      var a = response.body.replaceAll("\"", "");

      if (a != 'false') {
        print("Response status: ${response.statusCode}");
//          print("Response body: $a");
        _token = a;
        print('token:$a');
        luu("$a");
        Navigator.of(context).pop();
        _dialogLogin('');

        var url = URL.getSemester;
        http.post(url, headers: {"access-token": a}).then((response) {
//            print("Response body: ${response.body}");
          print("Response status: ${response.statusCode}");
          var data = json.decode(response.body);

//            for (int i = 0; i < data.length; i++) {
//              print(data[i]["TenKy"]);
//            }
          Navigator.of(context).pop();
          alert2(data);
        });
      } else {
        Navigator.of(context).pop();
        alert("Tài khoản mật khẩu không chính xác");
      }
    });
  }

  void getLichHoc(String semester, String token) {
    if (semester == "ngu") {
      alert("LOI");
    } else {
      print("maky $semester");
      var url = URL.getLichHoc;
      http.post(url,
          headers: {"access-token": token},
          body: {"semester": semester}).then((response) {
        lichhoc = true;
        if (response.statusCode == 200) {
          print('lich hoc=${response.body}');
          print(response.statusCode);
          /**
           * fake lich hoc :)
           */
          luuLichHoc(response.body);
          if (lichthi && lichhoc && diem && profile && lichthilai) {
            storageHelper.login().then((file) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("MyHomePage");
            });
          }
        } else {}
      });
    }
  }

  void getLichThi(String semester, String token) {
    if (semester == "ngu") {
      alert("LOI");
    } else {
      print("maky $semester");
      var url = URL.getLichThi;
      http.post(url,
          headers: {"access-token": token},
          body: {"semester": semester}).then((response) {
        lichthi = true;
        if (response.statusCode == 200) {
          print('lich thi=${response.body}');

          print(response.statusCode);
          luuLichThi(response.body);
          if (lichthi && lichhoc && diem && profile && lichthilai) {
            storageHelper.login().then((file) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("MyHomePage");
            });
          }
        } else {}
      });
    }
  }

  void getLichThiLai(String semester, String token) {
    if (semester == "ngu") {
      alert("LOI");
    } else {
      print("maky $semester");
      var url = URL.getLichThi;
      http.post(url,
          headers: {"access-token": token},
          body: {"semester": semester}).then((response) {
        lichthilai = true;
        if (response.statusCode == 200) {
          print('lich thi=${response.body}');
          print(response.statusCode);
          luuLichThiLai(response.body);
          if (lichthi && lichhoc && diem && profile && lichthilai) {
            storageHelper.login().then((file) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("MyHomePage");
            });
          }
        } else {}
      });
    }
  }

  void getDiem(String token) {
    var url = URL.getDiem;
    http.post(url, headers: {"access-token": token}).then((response) {
      diem = true;
      if (response.statusCode == 200) {
        print("Response body(diem): ${response.body}");
        print(response.statusCode);
        luuDiem(response.body);
        if (lichthi && lichhoc && diem && profile && lichthilai) {
          storageHelper.login().then((file) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed("MyHomePage");
          });
        }
      } else {}
    });
  }

  void getProfile(String token) {
    var url = URL.getProfile;
    http.post(url, headers: {"access-token": token}).then((response) {
      profile = true;
      if (response.statusCode == 200) {
        print(response.statusCode);
        luuProfile(response.body);
        if (lichthi && lichhoc && diem && profile && lichthilai) {
          storageHelper.login().then((file) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed("MyHomePage");
          });
        }
      } else {}
      //print("Response body: ${response.body}");
    });
  }

  luu(String token) {
    storageHelper.writeFile('$token', Path.token);
  }

  luuProfile(String token) {
    storageHelper.writeFile('$token', Path.profileUser);
  }

  luuDiem(String token) {
    storageHelper.writeFile('$token', Path.Diem);
  }

  luuLichHoc(String token) {
    storageHelper.saveLichHoc(token);
  }

  luuLichThi(String token) {
    storageHelper.saveLichThi(token);
  }

  luuLichThiLai(String lich) {
    storageHelper.saveLichThiLai(lich);
  }

  void loadData(String semester, String semesterKyTruoc) {
    _dialogLogin("Đang xử lý dữ liệu. Vui lòng đợi");
    getLichHoc(semester, _token);
    getLichThi(semester, _token);
    if (semesterKyTruoc.isNotEmpty) {
      getLichThiLai(semesterKyTruoc, _token);
    }
    getDiem(_token);
    getProfile(_token);
  }

  Widget buildRow(BuildContext context, data, kyTruoc) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Tên Kỳ: ${data["TenKy"]}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.of(context).pop();
            _semester = data["MaKy"];
            print(_semester);
            if (kyTruoc != null) {
              _semesterKyTruoc = kyTruoc["MaKy"];
              print(_semesterKyTruoc);
            }
            loadData(_semester, _semesterKyTruoc);
          },
        ),
        Divider()
      ],
    );
  }

  void alert2(data) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Chọn kỳ học'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext buildContext, int index) => buildRow(
                    context,
                    data[index],
                    index == data.length - 1 ? null : data[index + 1]),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, child: alertDialog);
  }

  void alert(String _msg) {
    AlertDialog dialog = new AlertDialog(
      title: Text('Đăng nhập thất bại'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(_msg),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(context: context, child: dialog);
  }
}
