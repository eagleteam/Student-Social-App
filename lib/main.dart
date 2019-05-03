import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_student_social/blocs/bloc_provider.dart';
import 'package:flutter_student_social/blocs/login/login_bloc.dart';
import 'package:flutter_student_social/login/login_page.dart';
import 'package:flutter_student_social/menu/Time_out_class.dart';
import 'package:flutter_student_social/main/main.dart';
import 'package:flutter_student_social/menu/diem_ngoai_khoa.dart';
import 'package:flutter_student_social/menu/mark_check.dart';
import 'package:flutter_student_social/support/storage_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MyHomePage.tag: (context) => MyHomePage(),
    TimeOut.tag: (context) => TimeOut(),
    MarkCheck.tag: (context) => MarkCheck(),
    DiemNgoaiKhoa.tag: (context) => DiemNgoaiKhoa()
  };
  Future<String> data;

  Future<String> getDataFromFile() async {
    StorageHelper storageHelper = StorageHelper();
    String login = await storageHelper.readFile(Path.logined);
    return login;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
    data = getDataFromFile();
  }

  Widget initWidget() {
    //chon man hinh hien thi tuy theo du lieu
    return new FutureBuilder<String>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.toString().isNotEmpty) {
            // co du lieu
            return MyHomePage();
          } else {
            return BlocProvider(
              child: LoginPage(),
              bloc: _loginBloc,
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        //mac dinh
        return Scaffold(
          body: Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Social',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: initWidget(),
      routes: routes,
    );
  }
}
