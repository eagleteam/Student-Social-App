import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_student_social/support/link.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_student_social/support/storage_helper.dart';

class UpdateLich extends StatefulWidget {
  final Function onClickSemester;
  final BuildContext mcontext;

  UpdateLich({this.onClickSemester, this.mcontext});

  @override
  _UpdateLichState createState() => _UpdateLichState();
}

class _UpdateLichState extends State<UpdateLich> {
  //doc ghi file
  StorageHelper storageHelper;
  String  _token;
  bool lichhoc = false,lichthi = false,lichthilai=true;

  @override
  void initState() {
    super.initState();
    storageHelper = StorageHelper();
    print('initstate update');
    loadSemester();
  }

  void loadSemester() async {
    var url = Link.getSemester;
    _token = await storageHelper.readFile(Path.token);
    http.post(url, headers: {"access-token": _token}).then((response) {
      print("Response body(load semester): ${response.body}");
      var data = json.decode(response.body);

      for (int i = 0; i < data.length; i++) {
        print(data[i]["TenKy"]);
      }
      Navigator.of(context).pop();
      showChonKiHoc(data);
    });
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

  luuLichHoc(String lich) {
    if(lich.isNotEmpty && lich != 'false') {
      storageHelper.saveLichHoc(lich).then((file) {
        if(lichhoc && lichthi&&lichthilai) {
          widget.onClickSemester('update');
        }
      });
    }else{
      if(lichhoc && lichthi&&lichthilai) {
        widget.onClickSemester('lich hoc empty or false');
      }
    }
  }
  luuLichThi(String lich) {
    if(lich.isNotEmpty && lich != 'false') {
      storageHelper.saveLichThi(lich).then((file) {
        if(lichhoc && lichthi&&lichthilai) {
          widget.onClickSemester('update');
        }
      });
    }else{
      if(lichhoc && lichthi&&lichthilai) {
        widget.onClickSemester('lich thi empty or false');
      }
    }
  }
  luuLichThiLai(String lich) {
    if(lich.isNotEmpty && lich != 'false') {
      storageHelper.saveLichThiLai(lich).then((file) {
        if(lichhoc && lichthi &&lichthilai) {
          widget.onClickSemester('update');
        }
      });
    }else{
      if(lichhoc && lichthi &&lichthilai) {
        widget.onClickSemester('lich thi empty or false');
      }
    }
  }

  void getLichHoc(String semester, String token) {
    if (semester == "ngu") {
      alert("LOI");
    } else {
      print("maky hoc $semester");
      var url = Link.getLichHoc;
      http.post(url,
          headers: {"access-token": token},
          body: {"semester": semester}).then((response) {
        lichhoc = true;
        if (response.statusCode == 200) {
          print('lich hoc=${response.body}');
          print(response.statusCode);
          luuLichHoc(response.body);
        } else {}
      });
    }
  }
  void getLichThi(String semester, String token) {
    if (semester == "ngu") {
      alert("LOI");
    } else {
      print("maky thi $semester");
      var url = Link.getLichThi;
      http.post(url,
          headers: {"access-token": token},
          body: {"semester": semester}).then((response) {
        lichthi = true;
        if (response.statusCode == 200) {
          print('lich thi=${response.body}');
          print(response.statusCode);
          luuLichThi(response.body);
        } else {}
      });
    }
  }
  void getLichThiLai(String semester, String token) {
    if (semester == "ngu") {
      alert("LOI");
    } else {
      print("maky thi lai$semester");
      var url = Link.getLichThi;
      http.post(url,
          headers: {"access-token": token},
          body: {"semester": semester}).then((response) {
        lichthilai = true;
        if (response.statusCode == 200) {
          print('lich thi lai=${response.body}');
          print(response.statusCode);
          luuLichThiLai(response.body);
        } else {}
      });
    }
  }

  void loadData(String semester,String semester2) {
//    _loading("Đang xử lý dữ liệu. Vui lòng đợi");
    widget.onClickSemester('loading');
    print('token is $_token');
    getLichHoc(semester, _token);
    getLichThi(semester, _token);
    if(semester2.isNotEmpty){
      lichthilai = false;
      getLichThiLai(semester2, _token);
    }
  }

  Widget buildRow(BuildContext context, data,data2) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Tên Kỳ: ${data["TenKy"]}",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              widget.onClickSemester('click to ${data["MaKy"]}');
              print('semester selected is ${data["MaKy"]}');
              if(data2 != null){
                //co du lieu data2 => co lich thi lai
                print('semester thi lai selected is ${data2["MaKy"]}');
              }
              loadData(data["MaKy"],data2["MaKy"]);
            },
          ),
          Divider()
        ],
      )
    );
  }

  void showChonKiHoc(data) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Chọn kỳ học'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext buildContext, int index) =>
                    buildRow(context, data[index],index < data.length - 1 ? data[index+1] : null),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
