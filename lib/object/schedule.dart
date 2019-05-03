import 'package:flutter_student_social/object/entries.dart';
import 'package:flutter_student_social/object/semester.dart';
import 'package:flutter_student_social/object/subjects.dart';

class Schedule {
  final List<Entries> entries;
  final Semester semester;
  final List<Subjects> subjects;
  Schedule({this.entries,this.semester,this.subjects});
  factory Schedule.fromJson(Map<String,dynamic> json){
    var listEntries = json['Entries'] as List;
    List<Entries> et = listEntries.map((i)=>Entries.fromJson(i)).toList();

    var se = json['Semester'];
//    List<Semester> se = listSemester.map((i)=>Semester.fromJson(i)).toList();

    var listSubjects = json['Subjects'] as List;
    List<Subjects> su = listSubjects.map((i)=>Subjects.fromJson(i)).toList();

    return Schedule(
      entries: et,
      semester: Semester.fromJson(se),
      subjects: su
    );
  }
}
