/*
 * Widget Dialog hien thi them ghi chu ^_^
 */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_student_social/support/storage_helper.dart';
import 'package:flutter_student_social/object/entries.dart';

class DialogAddGhiChu extends StatefulWidget {
  final Function onAddedNote;
  final DateTime date;
  DialogAddGhiChu({this.onAddedNote,this.date});
  @override
  _DialogAddGhiChuState createState() => _DialogAddGhiChuState();
}

class _DialogAddGhiChuState extends State<DialogAddGhiChu> {
  final dateFormat = DateFormat("yyyy-MM-dd");
  DateTime _date;

  //khai bao bien formkey de quan li,validate from them ghi chu
  final formKey = GlobalKey<FormState>();

  //khai bao bien cho phan ghi chu
  String _tieuDe = '', _noiDung = '';
  StorageHelper storageHelper;

  @override
  void initState() {
    super.initState();
    _date  = widget.date;
    storageHelper = StorageHelper();
  }

  /*
   * xu ly su kien khi bam them ghi chu
   */
  void actionThemGhiChu() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Entries entries = Entries(
          MaMon: _tieuDe,
          ThoiGian: _noiDung=='' ? 'Trống' : _noiDung,
          Ngay: dateFormat.format(_date),
          DiaDiem: '',
          HinhThuc: '',
          GiaoVien: '',
          LoaiLich: '',
          SoBaoDanh: '');
      storageHelper.addGhiChu('!${entries.getJsonForNote()}').then((file) {
        storageHelper.saveNoteToF();
        Navigator.of(context).pop();
        widget.onAddedNote('added');
      });
    }
  }

  /*
   * show picker time
   */
  Future<Null> _pickerTime() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2030));
    if (picked != null && picked != _date) {
      print('date selected is ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  /*
   * cac widget con
   */

  TextFormField tieuDe() {
    return TextFormField(
      maxLines: 1,
      onSaved: (value) => _tieuDe = value,
      validator: (value) {
        if (value.isEmpty) {
          return 'Không được để trống';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: 'Tiêu đề',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  TextFormField noiDung() {
    return TextFormField(
      maxLines: 3,
      onSaved: (value) => _noiDung = value,
      decoration: InputDecoration(
          hintText: 'Nội dung (không bắt buộc)',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  Wrap chonNgay() {
    return Wrap(
      children: <Widget>[
        RaisedButton(
          child: Text(
            dateFormat.format(_date),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
//            _pickerTime();
          },
          color: Colors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
        SizedBox(width: 10,),
        RaisedButton(
          child: Text(
            'Chọn ngày',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _pickerTime();
          },
          color: Colors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm ghi chú'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
//          height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  tieuDe(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                  ),
                  noiDung(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                  ),
                  chonNgay()
                ]),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('HUỶ BỎ',style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(child: Text('THÊM MỚI'), onPressed: actionThemGhiChu)
      ],
    );
  }
}
