import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_student_social/blocs/bloc_provider.dart';
import 'package:flutter_student_social/blocs/login/action.dart';
import 'package:flutter_student_social/blocs/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  static final String tag = 'login-page';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  FocusNode textSecondFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    try {
      _loginBloc = BlocProvider.of<LoginBloc>(context);
    } catch (e) {
      _loginBloc = LoginBloc();
    }
    _initActionListen();
  }

  void _initActionListen() {
    //TODO('listen action')
    _loginBloc.action.listen((value) {
      switch (value.action) {
        case Action.focusToPassword:
          FocusScope.of(context).requestFocus(textSecondFocusNode);
          break;
        case Action.showDialog:
          _loginFailed(value.data);
          break;
        case Action.showLoading:
          _dialogLoading();
          break;
        case Action.showDialogChonKy:
          _dialogChonKy(value.data);
          break;
        case Action.push:
          Navigator.of(context).pushNamed(value.data);
          break;
        case Action.pop:
          Navigator.of(context).pop();
          break;
      }
    });
  }

  Widget _logo() {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 80,
      backgroundImage: AssetImage('image/Logo.png'),
    );
  }

  Widget _user(AsyncSnapshot snapshot) {
    return TextField(
      controller: TextEditingController(text: 'dtc165d4801030252'),
      autofocus: true,
      textCapitalization: TextCapitalization.characters,
      onChanged: _loginBloc.onUserChange,
      onSubmitted: _loginBloc.onUserSubmit,
      decoration: InputDecoration(
        hintText: 'Mã sinh viên',
        labelText: 'Mã sinh viên',
        errorText: snapshot.error,
        prefixIcon: Icon(Icons.account_circle),
        suffixIcon: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: _loginBloc.onUserEnter,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _password(AsyncSnapshot snapshot) {
    return TextField(
      controller: TextEditingController(text: 'tbm01031998'),
      focusNode: textSecondFocusNode,
      obscureText: true,
      onChanged: _loginBloc.onPasswordChange,
      onSubmitted: _loginBloc.onPasswordSubmit,
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        labelText: 'Mật khẩu',
        errorText: snapshot.error,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
            icon: Icon(Icons.check), onPressed: _loginBloc.onPasswordEnter),
        contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.all(0),
      child: RaisedButton(
        child: Text('ĐĂNG NHẬP', style: TextStyle(color: Colors.white)),
        onPressed: _loginBloc.onPessedLoginButton,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.green,
      ),
    );
  }

  Future<bool> _canLeave(BuildContext context) {
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => _canLeave(context),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _logo(),
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
                  StreamBuilder(
                      stream: _loginBloc.user,
                      builder: (context, snapshot) {
                        return _user(snapshot);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                  ),
                  StreamBuilder(
                      stream: _loginBloc.password,
                      builder: (context, snapshot) {
                        return _password(snapshot);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                  ),
                  _loginButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _dialogChonKy(data) {
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
    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  Widget buildRow(BuildContext context, data, kyTruoc) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Kỳ: ${data["TenKy"]}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            _loginBloc.onPressedKyHoc(data, kyTruoc);
          },
        ),
        Divider()
      ],
    );
  }

  void _loginFailed(String _msg) {
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
    showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
  }
}
