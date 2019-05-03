import 'package:flutter_student_social/object/schedule.dart';
import 'package:flutter_student_social/object/semester.dart';
import 'dart:convert';

class JsonHelper{
  Schedule parseSchedule(String response){
    // da check response tu truoc , dam bao response co gia tri
    return Schedule.fromJson(json.decode(response));
  }
  Semester parseSemeter(String response){
    // da check response tu truoc , dam bao response co gia tri
    return Semester.fromJson(json.decode(response));
  }
}