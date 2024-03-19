import 'package:pantori/domain/ports.dart';

import 'package:intl/intl.dart';

class TimeMock implements TimePort {
  @override
  bool isDateBeforeDaysFromNow(String date, int days) {
    DateTime currentDate = DateTime(2045, 12, 01);
    DateTime formatedDate = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(date);
    bool out = formatedDate.isBefore(currentDate.add(Duration(days: days)));
    return out;
  }

  @override
  String getTodaysDate(){
    return "";
  }
}
