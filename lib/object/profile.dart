class Profile {
  //{"MaSinhVien":"DTC165D4801030252",
  // "HoTen":"Tr\u1ea7n B\u00ecnh Minh",
  // "NienKhoa":"K15",
  // "Lop":"KTPM K15A",
  // "Nganh":"K\u1ef9 thu\u1eadt ph\u1ea7n m\u1ec1m (2)",
  // "Truong":"\u0110\u1ea1i H\u1ecdc C\u00f4ng Ngh\u1ec7 Th\u00f4ng Tin & Truy\u1ec3n Th\u00f4ng - \u0110\u1ea1i H\u1ecdc Th\u00e1i Nguy\u00ean",
  // "HeDaoTao":"DHCQ"}
  final String MaSinhVien;
  final String HoTen;
  final String NienKhoa;
  final String Lop;
  final String Nganh;
  final String Truong;
  final String HeDaoTao;

  Profile(
      {this.MaSinhVien,
      this.HoTen,
      this.NienKhoa,
      this.Lop,
      this.Nganh,
      this.Truong,
      this.HeDaoTao});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        MaSinhVien: json['MaSinhVien'].toString(),
        HoTen: json['HoTen'].toString(),
        NienKhoa: json['NienKhoa'].toString(),
        Lop: json['Lop'].toString(),
        Nganh: json['Nganh'].toString(),
        Truong: json['Truong'].toString(),
        HeDaoTao: json['HeDaoTao'].toString());
  }
}
