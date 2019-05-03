class DateSupport {
  var Time1 = ["06:30-07:20","07:25-08:15",
  "08:25-09:15","09:25-10:15","10:20-11:10",
  "13:00-13:50","13:55-14:45","14:55-15:45",
  "15:55-16:45","16:50-17:40","18:15-19:05",
  "19:10-20:00"];
  var Time2 = ["06:45-07:35","07:40-08:30",
  "08:40-09:30","09:40-10:30","10:35-11:25",
  "13:00-13:50","13:55-14:45","14:55-15:45",
  "15:55-16:45","16:50-17:40","18:15-19:05",
  "19:10-20:00"];
  DateTime _now;
  //define constructors
  DateSupport(){
    this._now = DateTime.now();
  }
  DateSupport.fromDate(this._now);
  DateSupport.frommUTC(int y,int m,int d){
    this._now = DateTime(y,m,d);
  }
  //define function
  DateTime getDateNow(){
    return this._now;
  }
  int getDay(){
    return this._now.day;
  }
  int getMonth(){
    return this._now.month;
  }
  int getYear(){
    return this._now.year;
  }
  int getDayOfWeek(){
    return this._now.weekday;
  }
  int getMaxDayOfMonth(int year,int month){
//    print(DateTime(year,month+1,0));
    //datetime(year,month+1,0) tuong duong voi ngay cuoi cung cua thang truoc no
    // 0/12/2018 => 30/11/2018
    return DateTime(year,month+1,0).day;
  }
  int getIndexDayOfWeek(int year,int month){
    return DateTime(year,month,1).weekday;
  }
  int getMua(){
    /**
     * return 1 neu la mua he
     * return 2 neu la mua dong
     * mua he bat dau tu 15/4
     * mua dong bat dau tu 15/10
     */
    int m = this._now.month;
    int d = this._now.day;
    if([1,2,3,11,12].contains(m)){
      return 2;
    }
    if(m == 4){
      if(d>=15){
        return 1;
      }else{
        return 2;
      }
    }
    if(m == 10){
      if(d>=15){
        return 2;
      }else{
        return 1;
      }
    }
    return 1;
  }
  int getTiet(){
    var Time11 = ["06:30-07:20","07:21-08:15",
    "08:16-09:15","09:16-10:15","10:16-11:10",
    "13:00-13:50","13:51-14:45","14:46-15:45",
    "15:46-16:45","16:46-17:40","18:15-19:05",
    "19:06-20:00"];
    var Time21 = ["06:45-07:35","07:36-08:30",
    "08:31-09:30","09:31-10:30","10:31-11:25",
    "13:00-13:50","13:51-14:45","14:46-15:45",
    "15:46-16:45","16:46-17:40","18:15-19:05",
    "19:06-20:00"];
    int mua = getMua();
    List<String> time;
    if(mua==1){
      time = Time11;
    }else{
      time = Time21;
    }
    int h = this._now.hour;
    int m = this._now.minute;
    for(int i = 0;i<time.length;i++){
      String time1 = time[i].split('-')[0];
      String time2 = time[i].split('-')[1];
      int h1 = int.parse(time1.split(':')[0]);
      int m1 = int.parse(time1.split(':')[1]);
      int h2 = int.parse(time2.split(':')[0]);
      int m2 = int.parse(time2.split(':')[1]);
      int Date1 = DateTime(_now.year,_now.month,_now.day,h1,m1).millisecondsSinceEpoch;
      int Date2 = DateTime(_now.year,_now.month,_now.day,h2,m2).millisecondsSinceEpoch;
      if(DateTime.now().millisecondsSinceEpoch>= Date1 && DateTime.now().millisecondsSinceEpoch <= Date2){
        return i+1;
      }
    }
    return 0;
  }
  String getThoiGian(String thoiGian){
    int mua = getMua();
    if(thoiGian.contains(",")){
      //co nhieu hon 1 tiet
      var tiets = thoiGian.split(",");
      int first = int.parse(tiets[0]);
      int last = int.parse(tiets[tiets.length-1]);

      if(mua == 1){
        //mua he lay lich Time1
        return '(${Time1[first-1].split("-")[0]} - ${Time1[last-1].split("-")[1]})';
      }else{
        return '(${Time2[first-1].split("-")[0]} - ${Time2[last-1].split("-")[1]})';
      }
    }else{
      //chi co 1 tiet :v
      int tiet = int.parse(thoiGian);
      if(mua == 1){
        //mua he lay lich Time1
        return '(${Time1[tiet-1].split("-")[0]} - ${Time1[tiet-1].split("-")[1]})';
      }else{
        return '(${Time2[tiet-1].split("-")[0]} - ${Time2[tiet-1].split("-")[1]})';
      }
    }
  }
}