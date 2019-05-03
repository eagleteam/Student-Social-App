import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_student_social/login/login_page.dart';
import 'package:flutter_student_social/main/index_click_day.dart';
import 'package:flutter_student_social/menu/CreatQR.dart';
import 'package:flutter_student_social/menu/Time_out_class.dart';
import 'package:flutter_student_social/menu/diem_ngoai_khoa.dart';
import 'package:flutter_student_social/menu/edit_note.dart';
import 'package:flutter_student_social/menu/mark_check.dart';
import 'package:flutter_student_social/object/entries.dart';
import 'package:flutter_student_social/object/profile.dart';
import 'package:flutter_student_social/object/schedule.dart';
import 'package:flutter_student_social/object/subjects.dart';
import 'package:flutter_student_social/support/storage_helper.dart';
import 'package:flutter_student_social/widget/calendar.dart';
import 'package:flutter_student_social/widget/dialog_add_ghichu.dart';
import 'package:flutter_student_social/widget/fancy_fab.dart';
import 'package:flutter_student_social/widget/list_schedule.dart';
import 'package:flutter_student_social/widget/update_lich.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _controller = new PageController(initialPage: 6);
  int _currentPage = 6;
  int _indexPageByChanged = 6;
  double _width = 0;
  Size _size;
  double _widthDrawer = 0;
  double _itemHeight = 0;
  double _itemWidth = 0;
  double _tableHeight =
      316; // title = 20, titleday = 30, tableheight = 250 , 16 margin
  int indexDay = 0;
  int maxDayOfMonth = 0;
  int month = 0;
  int year = 0;
  int indexPage = 0;
  final DateTime currentDate = DateTime.now();
  DateTime stateDate;
  Map<String, List<Entries>> entriesOfDay;
  List<Subjects> listSubjects;
  DateTime _date = DateTime.now();

  //cac bien de get data tu file
  Future<String> dataFuture;
  Future<String> nameFuture;
  Future<String> classFuture;
  Future<String> msvFuture;
  String _msv = '';
  StorageHelper storageHelper;
  static bool init = false;
  bool coLichThiLai = false;

  @override
  void initState() {
    super.initState();
    storageHelper = StorageHelper();
    dataFuture = getLichFromFile();
    nameFuture = getNameFromProfile();
    classFuture = getClassFromProfile();
    msvFuture = getMSVFromProfile();
  }

  _initSize() {
    this._size = MediaQuery.of(context).size;
    this._width = this._size.width;
    this._widthDrawer = this._width * 3 / 4;
    this._itemHeight = 250 / 6;
    this._itemWidth = this._width / 7;
  }

  _initEntriesByLich(String lich) {
    print('value of lich: $lich');
    Schedule schedule = Schedule.fromJson(json.decode(lich
        .replaceAll('\t', ', ')
        .replaceAll('\r', ', ')
        .replaceAll('\n', ', ')));
    List<Entries> entries = schedule.entries;
    if (this.listSubjects == null) {
      this.listSubjects = List<Subjects>();
    }
    this.listSubjects.addAll(schedule.subjects);
    //khoi tao entriesOfDay, neu khoi tao roi thi dung tiep
    if (this.entriesOfDay == null) {
      this.entriesOfDay = Map<String, List<Entries>>();
    }
    int len = entries.length;
    Entries entri;
    for (int i = 0; i < len; i++) {
      entri = entries[i];
      if (this.entriesOfDay[entri.Ngay] == null) {
        this.entriesOfDay[entri.Ngay] = List<Entries>();
        // neu ngay cua entri nay chua co lich thi phai khoi tao trong map 1 list de luu lai duoc,
        //neu co roi thi thoi dung tiep
      }
      this.entriesOfDay[entri.Ngay].add(entri);
    }
  }

  _initEntriesByNote(String note) {
    print('value of note:$note');
    List<Entries> entries = List<Entries>();
    var splitNote = note.split('!');
    int len = splitNote.length;
    for (int i = 0; i < len; i++) {
      entries.add(Entries.fromJson(json.decode(splitNote[i]
          .replaceAll('\t', ', ')
          .replaceAll('\r', ', ')
          .replaceAll('\n', ', '))));
    }
//    print(entries);
    //khoi tao entriesOfDay, neu khoi tao roi thi dung tiep
    if (this.entriesOfDay == null) {
      this.entriesOfDay = Map<String, List<Entries>>();
    }
    len = entries.length;
    Entries entri;
    for (int i = 0; i < len; i++) {
      entri = entries[i];
      if (this.entriesOfDay[entri.Ngay] == null) {
        this.entriesOfDay[entri.Ngay] = List<Entries>();
        // neu ngay cua entri nay chua co lich thi phai khoi tao trong map 1 list de luu lai duoc,
        //neu co roi thi thoi dung tiep
      }
      this.entriesOfDay[entri.Ngay].add(entri);
    }
  }

  _initEntries(String value) {
    if (value.isEmpty)
      return; //neu gia tri ban dau rong thi se khong can initentries nua , return luon
    if (init == true) {
      print('da init data xong');
      return;
    } else {
      print('bat dau init dulieu');
    }
    print('init value is:$value');
    init = true;
    //clear entries map truoc khi init lan thu 2 tro di
    if (this.entriesOfDay != null) {
      this.entriesOfDay.clear();
    }
    if (value.contains('|')) {
      //co 2 lich tro len
      var lichs = value.split('|');
      //lich[0] la lich hoc, [1] la lich thi
      _initEntriesByLich(lichs[0]);
      _initEntriesByLich(lichs[1]);
      if (lichs.length >= 3) {
//        print('ghi chu:${lichs[2].substring(1)}');
        if (coLichThiLai) {
          //thang thu 3 se la lich thi lai
          _initEntriesByLich(lichs[2]);
          if (lichs.length > 3) _initEntriesByNote(lichs[3].substring(1));
        } else {
          //deo co lich thi lai
          //auto thang thu 3 la ghi chu
          _initEntriesByNote(lichs[2].substring(1));
        }
      }
    } else {
      //lich chi co 1 loai la lich hoc
      _initEntriesByLich(value);
    } //      setState(() {});
  }

  String getStringForKey(int i) {
    if (i < 10) {
      return '0$i';
    }
    return i.toString();
  }

  clickedOnDay(int day, int month, int year) {
    _currentPage = _indexPageByChanged;
    print(
        'clickedOnDay ${getStringForKey(day)},${getStringForKey(month)},$year from calendar_widget');
    _date = DateTime(year, month, day);
    setState(() {
      IndexClickDay.keyOfEntries =
          '$year-${getStringForKey(month)}-${getStringForKey(day)}';
    });
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      alert('Không có kết nối mạng :(');
    } else if (result == ConnectivityResult.mobile) {
      showDialogUpdateLich();
    } else if (result == ConnectivityResult.wifi) {
      showDialogUpdateLich();
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
    showDialog(context: context,builder: (context){
      return dialog;
    });
  }

  onPressedFab(String content) {
    print('onPressedFab is $content');
    switch (content) {
      case FancyFab.themghichu:
        showDialogAddGhiChu();
        break;
      case FancyFab.capnhatlich:
        _checkInternetConnectivity();
        break;
    }
  }

  /*
   * xu ly su kien sau khi them ghi chu xong(update future
   */
  onAddedNote(String value) {
    setState(() {
      dataFuture = getLichFromFile();
    });
  }

  Future<void> _dialogLogin(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  /*
   * xly click semester khi updatelich
   */
  onClickSemester(String value) async {
    if (value == 'loading') {
      _dialogLogin("Đang xử lý dữ liệu. Vui lòng đợi");
    } else if (value == 'update') {
      Navigator.of(context).pop();
      _dialogUpdateSuccess();
      setState(() {
        print('update data sau khi update');
        init = false;
        dataFuture = getLichFromFile();
      });
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _dialogUpdateSuccess() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          contentPadding: EdgeInsets.all(6),
          content: ListTile(
              title: Text('Cập nhật lịch thành công !'),
              leading: CircleAvatar(
                child: Icon(Icons.check),
              )),
        ); //magic ^_^
      },
    );
  }

  /*
   * show dialog khi bao vao update lich
   */

  Future<void> showDialogUpdateLich() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return UpdateLich(
          onClickSemester: (value) => onClickSemester(value),
          mcontext: context,
        ); //magic ^_^
      },
    );
  }

  /*
   * show dialog khi bam vao them ghi chu
   */

  Future<void> showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return DialogAddGhiChu(
          onAddedNote: (value) => onAddedNote(value),
          date: _date,
        ); //magic ^_^
      },
    );
  }

  Widget calendarView() {
    return Container(
        width: double.infinity,
        height: this._tableHeight,
        child: PageView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return Calendar(
                indexPage: index,
                width: this._width,
                itemWidth: this._itemWidth,
                itemHeight: this._itemHeight,
                entriesOfDay: this.entriesOfDay,
                clickedOnDay: (day, month, year) =>
                    clickedOnDay(day, month, year));
          },
          onPageChanged: (int index) {
            print('onpagechanged:$index');
//            _currentPage = index;
            _indexPageByChanged = index;
          },
        ));
  }

  int _counter = 0;

  updatePageNext(int month) {
    print('update page next $month and ${IndexClickDay.clickMonth}');
    if (month != IndexClickDay.clickMonth) {
      ++_currentPage;
    }
    _controller.jumpToPage(_currentPage);
    print('current page is $_currentPage');
  }

  updatePageBack(int month) {
    print('update page back $month and ${IndexClickDay.clickMonth}');
    if (month != IndexClickDay.clickMonth) {
      --_currentPage;
    }
    _controller.jumpToPage(_currentPage);
    print('current page is $_currentPage');
  }

  nextDay() {
    DateTime dateTime = DateTime(IndexClickDay.clickYear,
            IndexClickDay.clickMonth, IndexClickDay.clickDay)
        .add(Duration(days: 1));
    int m = IndexClickDay.clickMonth;
    IndexClickDay.clickDay = dateTime.day;
    IndexClickDay.clickMonth = dateTime.month;
    IndexClickDay.clickYear = dateTime.year;
    _counter++;
    clickedOnDay(IndexClickDay.clickDay, IndexClickDay.clickMonth,
        IndexClickDay.clickYear);
    updatePageNext(m);
  }

  backDay() {
    DateTime dateTime = DateTime(IndexClickDay.clickYear,
            IndexClickDay.clickMonth, IndexClickDay.clickDay)
        .add(Duration(days: -1));
    int m = IndexClickDay.clickMonth;
    IndexClickDay.clickDay = dateTime.day;
    IndexClickDay.clickMonth = dateTime.month;
    IndexClickDay.clickYear = dateTime.year;
    _counter--;
    clickedOnDay(IndexClickDay.clickDay, IndexClickDay.clickMonth,
        IndexClickDay.clickYear);
    updatePageBack(m);
  }

  Widget listSchedule() {
    return Expanded(
        child: Dismissible(
      resizeDuration: null,
      onDismissed: (DismissDirection direction) {
//        setState(() {
//          _counter += direction == DismissDirection.endToStart ? 1 : -1;
////              IndexClickDay.currentDay += _counter;
//        });
        if (direction == DismissDirection.endToStart) {
          nextDay();
        } else {
          backDay();
        }
//        setState(() {
//
//        });
      },
      key: new ValueKey(_counter),
      child: ListSchedule(
        entriesOfDay: this.entriesOfDay,
        listSubjects: this.listSubjects,
      ),
    ));
  }

  Future<String> getNameFromProfile() async {
    String dataProfile = await storageHelper.readFile(Path.profileUser);
    Profile pro = Profile.fromJson(json.decode(dataProfile
        .replaceAll('\t', ', ')
        .replaceAll('\r', ', ')
        .replaceAll('\n', ', ')));
    return pro.HoTen;
  }

  Future<String> getClassFromProfile() async {
    String dataProfile = await storageHelper.readFile(Path.profileUser);
    Profile pro = Profile.fromJson(json.decode(dataProfile
        .replaceAll('\t', ', ')
        .replaceAll('\r', ', ')
        .replaceAll('\n', ', ')));
    return pro.Lop;
  }

  Future<String> getMSVFromProfile() async {
    String dataProfile = await storageHelper.readFile(Path.profileUser);
    Profile pro = Profile.fromJson(json.decode(dataProfile
        .replaceAll('\t', ', ')
        .replaceAll('\r', ', ')
        .replaceAll('\n', ', ')));
    _msv = pro.MaSinhVien;
    return pro.MaSinhVien;
  }

  Future<String> getLichFromFile() async {
    String lichHoc = await storageHelper.readFile(Path.lichHoc);
    String lichThi = await storageHelper.readFile(Path.lichThi);
    String lichThiLai = await storageHelper.readFile(Path.lichThiLai);
    String ghiChu = await storageHelper.readFile(Path.ghiChu);
    nameFuture = getNameFromProfile();
    classFuture = getClassFromProfile();
    msvFuture = getMSVFromProfile();
//    print('ghi chu la=$ghiChu');
    String lich = '';
    if (lichHoc.isNotEmpty) {
      lich += lichHoc;
    }
    if (lichThi.isNotEmpty) {
      lich += '|$lichThi';
    }
    if (lichThiLai.isNotEmpty) {
      lich += '|$lichThiLai';
      coLichThiLai = true;
    }
    if (ghiChu.isNotEmpty) {
      lich += '|$ghiChu';
    }
    // lichhoc,lich thi co cung dinh dang, nen se return theo dinh dang
    // {(lich hoc)}|{(lich thi)}
    // khi kiem tra neu co '|' thi se la co ca lich thi, neu khong co thi chi co lich hoc
    init = false;
    return lich;
  }

  Future logOut() async {
    File logout = await storageHelper.logOut();
    // cho cho thuc thi xong het thi moi chay tiep cac cau lenh tiep theo
  }

  Widget futureName() {
    return new FutureBuilder<String>(
      future: nameFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data.toString(),
            style: TextStyle(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Text(
          'Tên sinh viên',
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  Widget futureClass() {
    return new FutureBuilder<String>(
      future: classFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data.toString(),
            style: TextStyle(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Text(
          'Lớp',
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  Widget futureMainWidget() {
    return FutureBuilder<String>(
      future: init ? dataFuture : getLichFromFile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _initEntries(snapshot.data.toString());
          return Column(
            children: <Widget>[
              SizedBox(
                height: 4,
              ),
              calendarView(),
              listSchedule()
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  DrawerHeader drawerHeader() {
    return DrawerHeader(
      child: Container(
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                backgroundImage: AssetImage('image/Logo.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                futureName(),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                ),
                futureClass()
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(color: Colors.green),
    );
  }

  Future<void> _loading1() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bạn có muốn đăng xuất không?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Không',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Đồng ý'),
              onPressed: () {
                logOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LoginPage.tag);
              },
            )
          ],
        );
      },
    );
  }

  _launchURL() async {
    const url = 'https://m.me/hoangthang1412';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _awaitReturnValueFromEditNote(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditNote(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      print('reload after edited note');
      init = false;
      dataFuture = getLichFromFile();
    });
  }

  List<Widget> listItemDrawer() {
    return [
      Container(height: 200, child: drawerHeader()),
//      ListTile(
//        title: Text('Ghi chú'),
//        leading: Image.asset('image/ic_note.png'),
//      ),
      ListTile(
        title: Text(
          'Thời gian ra vào lớp',
          style: TextStyle(color: Colors.green),
        ),
        leading: Icon(
          Icons.access_time,
          size: 30,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(TimeOut.tag);
        },
      ),
      Divider(
        height: 6,
      ),
      ListTile(
        title:
            Text('Hoạt động ngoại khoá', style: TextStyle(color: Colors.green)),
        leading: Icon(
          Icons.stars,
          size: 30,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(DiemNgoaiKhoa.tag);
        },
      ),
      Divider(
        height: 6,
      ),
      ListTile(
        title: Text('Tra cứu điểm', style: TextStyle(color: Colors.green)),
        leading: Icon(
          Icons.star,
          size: 30,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(MarkCheck.tag);
        },
      ),
      Divider(
        height: 6,
      ),
      ListTile(
        title: Text('Quản lý ghi chú', style: TextStyle(color: Colors.green)),
        leading: Icon(
          Icons.mode_edit,
          size: 30,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pop();
          _awaitReturnValueFromEditNote(context);
        },
      ),
      Divider(
        height: 6,
      ),
      ListTile(
        title: Text('Tạo QR CODE', style: TextStyle(color: Colors.green)),
        leading: Icon(
          Icons.blur_on,
          size: 30,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => QrImage(
                      data: _msv,
                    ),
              ));
        },
      ),
      Divider(
        height: 6,
      ),
      ListTile(
        title: Text('Hỗ trợ', style: TextStyle(color: Colors.green)),
        leading: Icon(
          Icons.contact_phone,
          size: 30,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pop();
          _launchURL();
        },
      ),
      Divider(
        height: 6,
      ),
      ListTile(
        title: Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.red),
        ),
        leading: Icon(
          Icons.exit_to_app,
          size: 30,
          color: Colors.red,
        ),
        onTap: () {
          Navigator.of(context).pop();
          _loading1();
//          logOut();
//          Navigator.of(context).pop();
//          Navigator.of(context).pushNamed(LoginPage1.tag);
        },
      ),
    ];
  }

  Drawer drawerWidget() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: listItemDrawer()),
    );
  }

  Future<bool> _canLeave(BuildContext context) {
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    _initSize();
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Social'),
      ),
      body: Form(
        child: Container(color: Colors.black12, child: futureMainWidget()),
        onWillPop: () => _canLeave(context),
      ),
      drawer: SizedBox(width: this._widthDrawer, child: drawerWidget()),
      floatingActionButton: FancyFab(
        onPressedFab: (content) => onPressedFab(content),
        type: FancyFab.xemlich,
      ),
    );
  }
}
