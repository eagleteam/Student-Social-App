class Subjects{
  final String MaMon;
  final String TenMon;
  final String HocPhan;
  final String SoTinChi;
  Subjects({this.MaMon,this.TenMon,this.HocPhan,this.SoTinChi});
  factory Subjects.fromJson(Map<String,dynamic> json){
    return Subjects(
      MaMon: json['MaMon'].toString(),
      TenMon: json['TenMon'].toString(),
      HocPhan: json['HocPhan'].toString(),
      SoTinChi: json['SoTinChi'].toString()
    );
  }
}