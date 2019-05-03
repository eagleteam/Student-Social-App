import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_student_social/main/main.dart';
import 'package:flutter_student_social/object/entries.dart';
import 'package:flutter_student_social/support/storage_helper.dart';

class EditNote extends StatefulWidget {
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Future<String> dataNote;
  StorageHelper storageHelper;
  List<Entries> entriesOfDay;

  @override
  void initState() {
    super.initState();
    storageHelper = StorageHelper();
    entriesOfDay = List<Entries>();
    dataNote = getMyDataNote();
  }

  Future<String> getMyDataNote() async {
    String note = await storageHelper.readFile(Path.ghiChu);
    return note;
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
      this.entriesOfDay = List<Entries>();
    }
    this.entriesOfDay.addAll(entries);
  }

  _initEntries(String value) {
    if (value.isEmpty) {
      print('note is empty');
      if (this.entriesOfDay != null) {
        this.entriesOfDay.clear();
      }
      return; //neu gia tri ban dau rong thi se khong can initentries nua , return luon
    }
    print('init value is:${value}');
    //clear entries map truoc khi init lan thu 2 tro di
    if (this.entriesOfDay != null) {
      this.entriesOfDay.clear();
    }
    _initEntriesByNote(value.substring(1));
  }

  Card layoutNote(int index) {
    return Card(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      color: Colors.purple,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            'Tiêu đề: ${this.entriesOfDay[index].MaMon} (${this.entriesOfDay[index].Ngay})',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            'Nội dung: ${this.entriesOfDay[index].ThoiGian}',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => deleteItem(index)),
            ],
          ),
        ),
      ),
    );
  }

  updateNoteToData() async {
    await this.storageHelper.writeFile('', Path.ghiChu);
    await this.storageHelper.delNote();
    for (int i = 0; i < this.entriesOfDay.length; i++) {
      await this
          .storageHelper
          .addGhiChu('!${this.entriesOfDay[i].getJsonForNote()}')
          .then((file) {
        storageHelper.saveNoteToF();
      });
    }
    MyHomePageState.init = false;
    setState(() {
      Navigator.of(context).pop();
      dataNote = getMyDataNote();
    });
  }

  Future<void> deleteItem(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bạn có muốn xoá ghi chú này không?'),
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
                this.entriesOfDay.removeAt(index);
                updateNoteToData();
              },
            )
          ],
        );
      },
    );
  }

  ListView listViewNote() {
    return ListView.builder(
        itemCount: this.entriesOfDay.length,
        itemBuilder: (context, index) {
          return layoutNote(index);
        });
  }

  FutureBuilder<String> listNoteBuilder() {
    return FutureBuilder<String>(
      future: this.dataNote,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _initEntries(snapshot.data.toString());
          if (this.entriesOfDay.isEmpty) {
            return Center(
              child: Text('Bạn chưa thêm ghi chú nào'),
            );
          }
          return listViewNote();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa ghi chú của bạn'),
      ),
      body: Container(child: listNoteBuilder()),
    );
  }
}
