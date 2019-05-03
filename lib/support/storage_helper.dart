import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_student_social/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Path{
  static const String token = "/token.txt";
  static const String lichHoc = "/lichHoc.txt";
  static const String lichThi = "/lichThi.txt";
  static const String lichThiLai = "/lichThiLai.txt";
  static const String ghiChu = "/ghiChu.txt";
  static const String profileUser = "/profileUser.txt";
  static const String Diem = '/Diem.txt';
  static const String logined = '/logined.txt';
  static const String initNotifi = '/initnotifi.txt';
  static const String diemNgoaiKhoa = '/diemngoaikhoa.txt';
}
class StorageHelper {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String pathFile) async {
    final path = await _localPath;
    return File('$path$pathFile');
  }

  Future<String> readFile(String pathFile) async {
    try {
      final file = await _localFile(pathFile);

      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  Future<File> login() async{
    return writeFile('login', Path.logined);
  }
  Future<File> logOut() async{
    await writeFile('', Path.lichHoc);
    await writeFile('', Path.lichThi);
    await writeFile('', Path.lichThiLai);
    await writeFile('', Path.ghiChu);
    await writeFile('', Path.diemNgoaiKhoa);
    delLichHoc();
    delLichThi();
    delLichThiLai();
    delNote();
    return writeFile('', Path.logined);
  }



  delLichHoc() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lichhoc', '');
  }
  delLichThi() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lichthi', '');
  }
  delLichThiLai() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lichthilai', '');
  }
  delNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('note', '');
  }

  saveLichHocToF(String lich) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lichhoc', lich);
  }
  saveLichThiToF(String lich) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lichthi', lich);
  }
  saveLichThiLaiToF(String lich) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lichthilai', lich);
  }
  saveNoteToF([String note = ""]) async {
    if(note.isEmpty){
      String notee = await readFile(Path.ghiChu);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('note', notee);
    }else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('note', note);
    }
  }

  Future<File> saveToken(String token) async{
    return writeFile(token, Path.token);
  }
  Future<String> loadToken() async{
    return await readFile(Path.token);
  }
  Future<File> saveLichHoc(String lich) async{
    saveLichHocToF(lich);
    return writeFile(lich, Path.lichHoc);
  }
  Future<File> saveLichThi(String lich) async{
    saveLichThiToF(lich);
    return writeFile(lich, Path.lichThi);
  }
  Future<File> saveLichThiLai(String lich) async{
    saveLichThiLaiToF(lich);
    return writeFile(lich, Path.lichThiLai);
  }
  Future<File> saveGhiChu(String note) async{
    saveNoteToF(note);
    return writeFile(note, Path.ghiChu);
  }
  Future<File> addGhiChu(String note) async{
    return writeFile(note, Path.ghiChu,FileMode.append);
  }
  Future<File> saveProfileUser(String profile) async{
    return writeFile(profile, Path.profileUser);
  }
  Future<File> saveDiem(String diem) async{
    return writeFile(diem, Path.Diem);
  }

  Future<File> writeFile(String text,String pathFile,[FileMode mode = FileMode.write]) async {
    final file = await _localFile(pathFile);
    return file.writeAsString(text, mode: mode);
  }

  Future<File> cleanFile(String pathFile) async {
    final file = await _localFile(pathFile);
    return file.writeAsString('');
  }
}