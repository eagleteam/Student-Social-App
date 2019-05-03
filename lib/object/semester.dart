class Semester{
  final String TenKy;
  final String MaKy;
  final String KyHienTai;

  Semester({this.TenKy, this.MaKy, this.KyHienTai});
  factory Semester.fromJson(Map<String,dynamic> json){
    return Semester(
      TenKy: json['TenKy'].toString(),
      MaKy: json['MaKy'].toString(),
      KyHienTai: json['KyHienTai'].toString()
    );
  }
}