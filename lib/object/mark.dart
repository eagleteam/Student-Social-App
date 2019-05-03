class Mark {
  final String MaMon;
  final String CC;
  final String KT;
  final String THI;
  final String TKHP;
  final String DiemChu;

  Mark({this.MaMon, this.CC, this.KT, this.THI, this.TKHP, this.DiemChu});

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
        MaMon: json['MaMon'].toString(),
        CC: json['CC'].toString(),
        KT: json['KT'].toString(),
        THI: json['THI'].toString(),
        TKHP: json['TKHP'].toString(),
        DiemChu: json['DiemChu'].toString());
  }
}
