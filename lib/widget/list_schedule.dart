import 'package:flutter/material.dart';
import 'package:flutter_student_social/main/index_click_day.dart';
import 'package:flutter_student_social/object/entries.dart';
import 'package:flutter_student_social/object/subjects.dart';
import 'package:flutter_student_social/support/date.dart';

class ListSchedule extends StatelessWidget {
  ListSchedule({this.entriesOfDay, this.listSubjects});

  final Map<String, List<Entries>> entriesOfDay;
  final List<Subjects> listSubjects;
  DateSupport dateSupport = DateSupport();

  String _tiet() {
    return dateSupport.getTiet().toString();
  }

  String getTenMon(String MaMon) {
    for (int i = 0; i < listSubjects.length; i++) {
      if (listSubjects[i].MaMon == MaMon) {
        return listSubjects[i].TenMon;
      }
    }
    return 'Không lấy được tên môn';
  }

  Widget layoutLichHoc(Entries entri) {
    print(_tiet());
    print(entri.ThoiGian);
    print(entri.ThoiGian.contains(_tiet()));
    if (entri.ThoiGian.contains(_tiet())) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                height: 30,
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Tiết'),
                    CircleAvatar(
                      child: Text(_tiet()),
                    ),
                    Text('đang diễn ra')
                  ],
                ),
              ),
            ),
            SizedBox(height: 6,),
            Text(
              'Môn học: ${getTenMon(entri.MaMon)}',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
                'Thời gian: ${entri.ThoiGian} ${this.dateSupport.getThoiGian(entri.ThoiGian)}',
                style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 6,
            ),
            Text('Địa điểm: ${entri.DiaDiem}',
                style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 6,
            ),
            Text(
              'Giảng viên: ${entri.GiaoVien}',
              style: TextStyle(color: Colors.white),
            )
          ]);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Môn học: ${getTenMon(entri.MaMon)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
              'Thời gian: ${entri.ThoiGian} ${this.dateSupport.getThoiGian(entri.ThoiGian)}',
              style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 6,
          ),
          Text('Địa điểm: ${entri.DiaDiem}',
              style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 6,
          ),
          Text(
            'Giảng viên: ${entri.GiaoVien}',
            style: TextStyle(color: Colors.white),
          )
        ],
      );
    }
  }

  Widget layoutLichThi(Entries entri) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Môn thi: ${getTenMon(entri.MaMon)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          'Số báo danh: ${entri.SoBaoDanh}',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 6,
        ),
        Text('Thời gian: ${entri.ThoiGian}',
            style: TextStyle(color: Colors.white)),
        SizedBox(
          height: 6,
        ),
        Text('Địa điểm: ${entri.DiaDiem}',
            style: TextStyle(color: Colors.white)),
        SizedBox(
          height: 6,
        ),
        Text('Hình thức: ${entri.HinhThuc}',
            style: TextStyle(color: Colors.white))
      ],
    );
  }

  Widget layoutNote(Entries entri) {
    return ListTile(
      contentPadding: EdgeInsets.all(2),
      title: Text(
        'Tiêu đề: ${entri.MaMon}',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: Text(
        'Nội dung: ${entri.ThoiGian}',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.cancel,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {}),
    );
  }

  Color getColor(String LoaiLich) {
    switch (LoaiLich) {
      case 'LichHoc':
        return Colors.blue;
      case 'LichThi':
        return Colors.red;
      case 'Note':
        return Colors.purple;
    }
  }

  Widget getLayoutEntri(Entries entri) {
    switch (entri.LoaiLich) {
      case 'LichHoc':
        return layoutLichHoc(entri);
      case 'LichThi':
        return layoutLichThi(entri);
      case 'Note':
        return layoutNote(entri);
    }
  }

  Widget ngayNghi() {
    return Container(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hôm nay bạn được nghỉ ',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(width: 30,height: 30, child: Image.asset('image/smile.png'))
          ],
        ),
        Text('(EagleTeam)')
      ],
    )));
  }

  Widget ngayHoc(List<Entries> entries) {
    return ListView.builder(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: getColor(entries[index].LoaiLich),
            elevation: 8,
            child: Container(
                padding: const EdgeInsets.only(
                    left: 16, top: 8, right: 16, bottom: 8),
                child: getLayoutEntri(entries[index])),
          );
        });
  }

  Widget listSchedule(List<Entries> entries) {
    if (entries.isEmpty) {
      return ngayNghi();
    }
    return ngayHoc(entries);
  }

  @override
  Widget build(BuildContext context) {
    if (this.entriesOfDay == null) {
      return listSchedule(List<Entries>());
    }
    List<Entries> entries = this.entriesOfDay[IndexClickDay.keyOfEntries];

    if (entries == null) {
      return listSchedule(List<Entries>());
    }
    entries.sort((a, b) => a.ThoiGian.compareTo(b.ThoiGian));
    return listSchedule(entries);
  }
}
