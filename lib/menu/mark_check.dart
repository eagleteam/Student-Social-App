import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_social/object/mark.dart';
import 'package:flutter_student_social/object/subjects.dart';
import 'package:flutter_student_social/support/link.dart';
import 'package:flutter_student_social/support/storage_helper.dart';
import 'dart:convert';
import 'package:flutter_student_social/widget/fancy_fab.dart';
import 'package:http/http.dart' as http;

class MarkCheck extends StatefulWidget {
  static const String tag = 'markcheck';

  @override
  _MarkCheckState createState() => _MarkCheckState();
}

class _MarkCheckState extends State<MarkCheck> {
  String _name, _msv, _token;
  int _tongTC, _stcXTN, _stcTL, _soMonKhongDat, _soTCKhongDat;
  double _dtbHS10, _dtbHS4;
  List<Subjects> _listSubjects;
  List<Mark> _listMark;
  List<Mark> _listMark2;
  String boloc = 'ALL';
  Future<String> dataFuture;
  StorageHelper storageHelper;

  @override
  void initState() {
    super.initState();
    storageHelper = StorageHelper();
    _listMark = List<Mark>();
    _listSubjects = List<Subjects>();
    dataFuture = getDiemFromFile();
  }

  List<Mark> getMarks(String loc) {
    if (_listMark2 == null) {
      _listMark2 = List<Mark>();
    } else {
      _listMark2.clear();
    }
    if (loc == 'ALL') {
      return _listMark;
    }
    int len = _listMark.length;
    for (int i = 0; i < len; i++) {
      if (_listMark[i].DiemChu == loc) {
        _listMark2.add(_listMark[i]);
      }
    }
    return _listMark2;
  }

  Future<String> getDiemFromFile() async {
    String dataDiem = await storageHelper.readFile(Path.Diem);
    _token = await storageHelper.readFile(Path.token);
    _initData(dataDiem);
    await Future.delayed(Duration(milliseconds: 300));
    return dataDiem;
  }

  _initData(String value) {
    Map<String, dynamic> jsons = json.decode(value);
    _tongTC = jsons['TongTC'];
    _stcXTN = jsons['STCTD'];
    _stcTL = jsons['STCTLN'];
    _soMonKhongDat = jsons['SoMonKhongDat'];
    _soTCKhongDat = jsons['SoTCKhongDat'];
    _dtbHS10 = double.parse(jsons['DTBC'].toString());
    _dtbHS4 = double.parse(jsons['DTBCQD'].toString());
    //
    var listMark = jsons['Entries'] as List;
    _listMark = listMark.map((i) => Mark.fromJson(i)).toList();
    //
    Map<String, dynamic> jsonsSemester = jsons['Semester'];
    //
    var listSubject = jsons['Subjects'] as List;
    _listSubjects = listSubject.map((i) => Subjects.fromJson(i)).toList();
    //
  }

  String getTenMon(String MaMon) {
    for (int i = 0; i < _listSubjects.length; i++) {
      if (_listSubjects[i].MaMon == MaMon) {
        return _listSubjects[i].TenMon;
      }
    }
  }

  int getSoTC(String MaMon) {
    for (int i = 0; i < _listSubjects.length; i++) {
      if (_listSubjects[i].MaMon == MaMon) {
        return int.parse(_listSubjects[i].SoTinChi);
      }
    }
  }

  Widget layoutMarkEntries(int index) {
    Mark mark = getMarks(boloc)[index];
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 8,bottom: 8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16,bottom: 8),
            child: Text(
              '${getTenMon(mark.MaMon)} (${getSoTC(mark.MaMon)}TC)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('CC'),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        mark.CC.isNotEmpty ? mark.CC : '  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('THI'),
                      SizedBox(
                        height: 4,
                      ),
                      Text(mark.THI.isNotEmpty ? mark.THI : '   ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('TKHP'),
                      SizedBox(
                        height: 4,
                      ),
                      Text(mark.TKHP.isNotEmpty ? mark.TKHP : '    ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('XL'),
                      CircleAvatar(
                          radius: 14,
                          backgroundColor: _getColorDiemChu(mark.DiemChu),
                          child: Text(
                              mark.DiemChu.isNotEmpty ? mark.DiemChu : '  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorDiemChu(String diemChu) {
    if (diemChu.isNotEmpty) {
      if (diemChu == 'A') {
        return Colors.green;
      }
      if (diemChu == 'B') {
        return Colors.blue;
      }
      if (diemChu == 'C') {
        return Colors.orange;
      }
      if (diemChu == 'D') {
        return Colors.yellow;
      }
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  Widget layoutDiem() {
    return Container(
      color: Colors.blue,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Tổng TC: $_tongTC',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                      ),
                      Text('STC XTN: $_stcXTN',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                      ),
                      Text('STC TL: $_stcTL',
                          style: TextStyle(color: Colors.white, fontSize: 18))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('ĐTB HS10: $_dtbHS10',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                      ),
                      Text('ĐTB HS4: $_dtbHS4',
                          style: TextStyle(color: Colors.white, fontSize: 18))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Số môn không đạt: $_soMonKhongDat',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Số tín chỉ không đạt: $_soTCKhongDat',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: getMarks(boloc).length,
              itemBuilder: (context, index) {
                return Container(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: layoutMarkEntries(index));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget layoutTrong() {
    return Center(
      child: Text('Trống'),
    );
  }

  Widget futureMainWidget() {
    //chon man hinh hien thi tuy theo du lieu
    return FutureBuilder(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.toString().isNotEmpty) {
            // co du lieu
//            _initData(snapshot.data.toString());
            return layoutDiem();
          } else {
            return layoutTrong();
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        //mac dinh
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /*
   * show dialog khi bao vao update diem
   */
  Widget _showLoadingKi() {
    return Center(child: CircularProgressIndicator(),);
  }

  Future<void> showDialogUpdateDiem() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return _showLoadingKi(); //magic ^_^
      },
    );
  }

  void actionLoc(String id) {
    Navigator.of(context).pop();
    setState(() {
      boloc = id;
    });
  }

  void showDialogLocDiem() {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Lọc điểm'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text('Tất cả'),
                onTap: () => actionLoc('ALL'),
              ),
              ListTile(
                title: Text('Xếp loại A'),
                onTap: () => actionLoc('A'),
              ),
              ListTile(
                title: Text('Xếp loại B'),
                onTap: () => actionLoc('B'),
              ),
              ListTile(
                title: Text('Xếp loại C'),
                onTap: () => actionLoc('C'),
              ),
              ListTile(
                title: Text('Xếp loại D'),
                onTap: () => actionLoc('D'),
              ),
              ListTile(
                title: Text('Xếp loại F'),
                onTap: () => actionLoc('F'),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('HUỶ BỎ'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  luuDiem(String token) {
    storageHelper.writeFile('$token', Path.Diem);
  }

  void getDiem() {
    var url = Link.getDiem;
    http.post(url, headers: {"access-token": _token}).then((response) {
      if (response.statusCode == 200) {
        print("Response body(diem): ${response.body}");
        var data = json.decode(response.body);
        print(response.statusCode);
        print(data);
        luuDiem(response.body);
        Navigator.of(context).pop();
        setState(() {
          dataFuture = getDiemFromFile();
        });
      } else {}
    });
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      alert('Không có kết nối mạng :(');
    } else if (result == ConnectivityResult.mobile) {
      showDialogUpdateDiem();
      getDiem();
    } else if (result == ConnectivityResult.wifi) {
      showDialogUpdateDiem();
      getDiem();
    }
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

  onPressedFab(String content) {
    print('onPressedFab is $content');
    switch (content) {
      case FancyFab.capnhatdiem:
        _checkInternetConnectivity();
        break;
      case FancyFab.loc:
        showDialogLocDiem();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tra cứu điểm'),
      ),
      body: futureMainWidget(),
      floatingActionButton: FancyFab(
        onPressedFab: (content) => onPressedFab(content),
        type: FancyFab.xemdiem,
      ),
    );
  }
}
