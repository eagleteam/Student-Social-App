import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_student_social/main/index_click_day.dart';
import 'package:flutter_student_social/support/date.dart';
import 'package:flutter_student_social/object/entries.dart';
import 'package:flutter_student_social/support/viet_calendar.dart';

class Calendar extends StatefulWidget {
  Calendar(
      {this.indexPage,
      this.width,
      this.itemWidth,
      this.itemHeight,
      this.entriesOfDay,
      this.clickedOnDay});

  final Map<String, List<Entries>> entriesOfDay;
  final int indexPage;
  final double width;
  final double itemWidth;
  final double itemHeight;

//  int height=0;
  final double tableHeight = 250;
  final DateSupport dateSupport = DateSupport();
  final Function clickedOnDay;

  //
  int getMonthByIndex(int index, int mode) {
    int m = currentMonth;
    int y = dateSupport.getYear();
    int delta = index - 6; // 6 la indexpage mac dinh
    if (delta < 0) {
      //thang < thang 11
      while (delta != 0) {
        m--;
        if (m == 0) {
          m = 12;
          y--;
        }
        delta++;
      }
    } else {
      //thang >= 11
      while (delta != 0) {
        m++;
        if (m == 13) {
          m = 1;
          y++;
        }
        delta--;
      }
    }
    if (mode == 1) {
      return m;
    } else {
      return y;
    }
  }

  int get currentDay {
    return dateSupport.getDay();
  }

  int get currentMonth {
    return dateSupport.getMonth();
  }

  int get month {
    return getMonthByIndex(indexPage, 1);
  }

  int get year {
    return getMonthByIndex(indexPage, 2);
  }

  int get maxDay {
    return dateSupport.getMaxDayOfMonth(year, month);
  }

  int get indexDayOfWeek {
    return dateSupport.getIndexDayOfWeek(year, month);
  }

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int _clickDay = -1;

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4,right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          dmyTitle(),
          titleDay(),
          Container(
            width: widget.width,
            height: widget.tableHeight,
            child: GridView.count(
              crossAxisCount: 7,
              // Generate 100 Widgets that display their index in the List
              childAspectRatio: (widget.itemWidth / widget.itemHeight),
              children: List.generate(42, (index) {
                return GridTile(
                  child: InkResponse(
                    enableFeedback: true,
                    onTap: () => onClickDay(index),
                    child: Center(
                      child: layoutOfDay(index),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget dmyTitle() {
    return Center(
      child: Container(
          height: 20,
          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            'Tháng ${widget.month} năm ${widget.year}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
    );
  }

  Widget gridViewDay() {
    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: (widget.itemWidth / widget.itemHeight),
      children: List.generate(7, (index) {
        return Container(
          child: Center(
            child: Text(
              '${getTitleDay(index)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }

  Widget titleDay() {
    return Container(
      width: widget.width,
      height: 30,
      child: gridViewDay(),
    );
  }

  String getTitleDay(index) {
    if (index == 6) return "CN";
    return "T${index + 2}";
  }

  onClickDay(int index) {
    _clickDay = getDay(index);
    if (_clickDay < 1 || _clickDay > widget.maxDay) {
      return;
    }
    print('click on day $_clickDay,stateMonth = ${widget.month}');
    print('------------------');
    IndexClickDay.clickDay = _clickDay;
    IndexClickDay.clickMonth = widget.month;
    widget.clickedOnDay(_clickDay, widget.month, widget.year);
    setState(() {});
  }

  int getDay(int indexcalendar) {
    return (widget.maxDay -
        ((widget.indexDayOfWeek - 1 - 1 + widget.maxDay) - (indexcalendar)));
  }

  Widget layoutOfDay(int indexcalendar) {
    if (indexcalendar >= widget.indexDayOfWeek - 1 &&
        indexcalendar < widget.indexDayOfWeek - 1 + widget.maxDay) {
      //nhung ngay trong pham vi cua thang hien tai
      return layoutDayByType(indexcalendar);
    }
    return Text('');
  }

  Widget currentDay(int day) {
    return Stack(
      alignment: const Alignment(1.0, -1.0),
      children: <Widget>[
        Container(
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            child: layoutDayDetail(day, widget.month),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.green
          ),
          child: Text(
            '${VietCalendar.lichAm(day, widget.month, widget.year)[0]}/${VietCalendar.lichAm(day, widget.month, widget.year)[1]}',
            style: TextStyle(fontSize: 10,color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget currentDayByClick(int day) {
    return Stack(
      alignment: const Alignment(1.0, -1.0),
      children: <Widget>[
        Container(
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: layoutDayDetail(day, widget.month),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green
          ),
          child: Text(
            '${VietCalendar.lichAm(day, widget.month, widget.year)[0]}',
            style: TextStyle(fontSize: 10,color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget normalDay(int day){
    return Stack(
      alignment: const Alignment(1.0,-1.0),
      children: <Widget>[
        Container(
          child: CircleAvatar(
            backgroundColor: Color(0xFFFFFF),
            child: layoutDayDetail(day, widget.month),
          ),
        ),
        Text(
            '${(VietCalendar.lichAm(day, widget.month, widget.year)[0] == 1) ? '${VietCalendar.lichAm(day, widget.month, widget.year)[0]}/${VietCalendar.lichAm(day, widget.month, widget.year)[1]}' : '${VietCalendar.lichAm(day, widget.month, widget.year)[0]}'}',
            style: TextStyle(fontSize: 10,color: Colors.grey),
          ),
      ],
    );
  }

  Widget layoutDayByType(int indexcalendar) {
    int day = getDay(indexcalendar);
    if (day == IndexClickDay.currentDay &&
        widget.month == IndexClickDay.currentMonth &&
        widget.year == IndexClickDay.currentYear) {
      return currentDay(day);
    }
    if (day == IndexClickDay.clickDay &&
        widget.month == IndexClickDay.clickMonth) {
      return currentDayByClick(day);
    }
    return normalDay(day);
  }

  List<Widget> getLayoutDayDetail(int day, int lichThi, int lichHoc, int note) {
    if (lichThi == 0 && lichHoc == 0 && note == 0) {
      return [
        Text(
          day.toString(),
          style: TextStyle(color: Colors.black87),
        )
      ];
    } else
      return [
        Text(day.toString(), style: TextStyle(color: Colors.black87)),
        layoutSubjectCount(lichThi, lichHoc, note)
      ];
  }

  String getStringForKey(int i) {
    if (i < 10) {
      return '0$i';
    }
    return i.toString();
  }

  Widget layoutDayDetail(int day, int month) {
    //• 1 cham the thien 1 lich
    String keyOfEntries =
        '${widget.year}-${getStringForKey(month)}-${getStringForKey(day)}';
    if (widget.entriesOfDay != null) {
      var entries = widget.entriesOfDay[keyOfEntries];
      int lichHoc = 0, lichThi = 0, note = 0;
      if (entries != null)
        for (int i = 0; i < entries.length; i++) {
          if (entries[i].LoaiLich == "LichHoc") {
            lichHoc++;
          }
          if (entries[i].LoaiLich == "LichThi") {
            lichThi++;
          }
          if (entries[i].LoaiLich == "Note") {
            note++;
          }
        }
      return Stack(
          alignment: const Alignment(0, 9),
          children: getLayoutDayDetail(day, lichThi, lichHoc, note));
    } else {
      return Stack(
          alignment: const Alignment(0, 9),
          children: getLayoutDayDetail(day, 0, 0, 0));
    }
  }

  String getDot(int count) {
    String s = '';
    for (int i = 0; i < count; i++) {
      s += '•';
    }
    return s;
  }

  Widget layoutSubjectCount(int lichThi, int lichHoc, int note) {
    if (lichThi + lichHoc + note >= 6) {
      // se la ••••+
      int lt = 0, lh = 0, nt = 0;
      if (lichThi >= 4) {
        lt = 4;
      } else {
        lt = lichThi;
      }
      if (lichHoc + lt >= 4) {
        lh = 4 - lt;
      } else {
        lh = lichHoc;
      }
      if (note + lt + lh >= 4) {
        nt = 4 - lt - lh;
      } else {
        nt = note;
      }
      lt = max(lt, 0);
      lh = max(lh, 0);
      nt = max(nt, 0);
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.red,
          ),
          children: <TextSpan>[
            TextSpan(text: getDot(lt)),
            TextSpan(
                text: getDot(lh),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            TextSpan(
                text: getDot(nt),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple)),
            TextSpan(
                text: '+',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.red,
          ),
          children: <TextSpan>[
            TextSpan(text: getDot(lichThi)),
            TextSpan(
                text: getDot(lichHoc),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            TextSpan(
                text: getDot(note),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple))
          ],
        ),
      );
    }
  }
}
