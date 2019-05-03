class IndexClickDay {
  static int clickDay = DateTime.now().day;
  static int clickMonth = DateTime.now().month;
  static int clickYear = DateTime.now().year;
  static int currentDay = DateTime.now().day;
  static int currentMonth = DateTime.now().month;
  static int currentYear = DateTime.now().year;
  static String keyOfEntries = '${getNum(IndexClickDay.currentYear)}-${getNum(IndexClickDay.currentMonth)}-${getNum(IndexClickDay.currentDay)}';
  static String getNum(int n){
    if(n<10){
      return '0$n';
    }
    return '$n';
  }
}
