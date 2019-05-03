import 'package:flutter/material.dart';
import 'package:flutter_student_social/support/date.dart';

class TimeOut extends StatefulWidget {
  static const String tag = 'timeout';

  @override
  _TimeOutState createState() => _TimeOutState();
}

class _TimeOutState extends State<TimeOut> {
  static const String tag = 'timeout';
  var Time1 = [
    "06:30 - 07:20",
    "07:25 - 08:15",
    "08:25 - 09:15",
    "09:25 - 10:15",
    "10:20 - 11:10",
    "13:00 - 13:50",
    "13:55 - 14:45",
    "14:55 - 15:45",
    "15:55 - 16:45",
    "16:50 - 17:40",
    "18:15 - 19:05",
    "19:10 - 20:00"
  ];
  var Time2 = [
    "06:45 - 07:35",
    "07:40 - 08:30",
    "08:40 - 09:30",
    "09:40 - 10:30",
    "10:35 - 11:25",
    "13:00 - 13:50",
    "13:55 - 14:45",
    "14:55 - 15:45",
    "15:55 - 16:45",
    "16:50 - 17:40",
    "18:15 - 19:05",
    "19:10 - 20:00"
  ];
  DateSupport _dateSupport;
  int _tiet;

  @override
  void initState() {
    super.initState();
    _dateSupport = DateSupport();
    _tiet = _dateSupport.getTiet();
    print('tiet is $_tiet');
  }

  Widget _getLayoutTime(int index) {
    if (index != _tiet) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Text(
                  '$index',
                  style: TextStyle(fontSize: 17),
                ))),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Text(Time1[index - 1], style: TextStyle(fontSize: 17))),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Text(Time2[index - 1], style: TextStyle(fontSize: 17))),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Text(
                  '$index',
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ))),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Text(Time1[index - 1],
                    style: TextStyle(color: Colors.red, fontSize: 17))),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Text(Time2[index - 1],
                    style: TextStyle(color: Colors.red, fontSize: 17))),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var descTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontFamily: 'Roboto',
      letterSpacing: 0.5,
      fontSize: 14.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Thời gian ra vào lớp'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 16, left: 8),
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Text('Lịch mùa hè bắt đầu từ 15/4',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12),
                    child: Text('Lịch mùa đông bắt đầu từ 15/10',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Center(
                                  child: Text(
                                'Tiết',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: (Text(
                                '    Mùa hè',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: (Text(
                                '    Mùa đông',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                        ],
                      ),
                    ),
                    new Divider(
                      color: Colors.green,
                    ),
                    _getLayoutTime(1),
                    Divider(),
                    _getLayoutTime(2),
                    Divider(),
                    _getLayoutTime(3),
                    Divider(),
                    _getLayoutTime(4),
                    Divider(),
                    _getLayoutTime(5),
                    Divider(),
                    _getLayoutTime(6),
                    Divider(),
                    _getLayoutTime(7),
                    Divider(),
                    _getLayoutTime(8),
                    Divider(),
                    _getLayoutTime(9),
                    Divider(),
                    _getLayoutTime(10),
                    Divider(),
                    _getLayoutTime(11),
                    Divider(),
                    _getLayoutTime(12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
