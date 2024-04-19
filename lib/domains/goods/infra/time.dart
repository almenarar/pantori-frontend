import 'package:pantori/domains/goods/core/ports.dart';

import 'package:intl/intl.dart';

class Time implements TimePort {
  @override
  bool isDateBeforeDaysFromNow(String date, int days) {
    DateTime currentDate = DateTime.now();
    DateTime formatedDate = DateFormat('dd/MM/yyyy').parse(date);
    bool out = formatedDate.isBefore(currentDate.add(Duration(days: days)));
    return out;
  }

  @override
  String getTodaysDate(){
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
}
