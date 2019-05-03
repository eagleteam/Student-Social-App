class Entries{
  /*
  "MaMon": "WED331",
            "ThoiGian": "6,7,8,9,10",
            "Ngay": "2018-09-08",
            "DiaDiem": "C6.PM302 C6",
            "HinhThuc": "Thực hành",
            "GiaoVien": "Nguyễn Thị Duyên",
            "LoaiLich": "LichHoc",
            "SoBaoDanh": ""
   */
  final String MaMon;
  final String ThoiGian;
  final String Ngay;
  final String DiaDiem;
  final String HinhThuc;
  final String GiaoVien;
  final String LoaiLich;
  final String SoBaoDanh;

  //
  Entries({this.MaMon, this.ThoiGian, this.Ngay, this.DiaDiem, this.HinhThuc,
    this.GiaoVien, this.LoaiLich, this.SoBaoDanh});
  factory Entries.fromJson(Map<String,dynamic> json){
    return Entries(
        MaMon: json['MaMon'].toString(),
        ThoiGian: json['ThoiGian'].toString(),
        Ngay: json['Ngay'].toString(),
        DiaDiem: json['DiaDiem'].toString(),
        HinhThuc: json['HinhThuc'].toString(),
        GiaoVien: json['GiaoVien'].toString(),
        LoaiLich: json['LoaiLich'].toString(),
        SoBaoDanh: json['SoBaoDanh'].toString()
    );
  }
  String getJsonForNote(){
    // note co cac thuoc tinh (tieude,noidung,ngay) se tuong ung voi (mamon,thoigian,ngay)
    return '{"MaMon":"$MaMon","ThoiGian":"$ThoiGian","Ngay":"$Ngay","DiaDiem":"","HinhThuc":"","GiaoVien":"","LoaiLich":"Note","SoBaoDanh":""}';
  }
}