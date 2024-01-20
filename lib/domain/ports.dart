import 'good.dart';

abstract class ServicePort {
  List<Good> filter(List<Good> goods, String category, String interval);
  List<String> listFilterIntervals();
  Future<void> login(String user, String pwd);
  Future<List<Good>> listGoods();
  Future<void> createGood(Good good);
  Future<void> deleteGood(Good good);
}

abstract class BackendPort {
  Future<void> login(String user, String pwd);
  Future<List<Good>> listGoods();
  Future<void> createGood(Good good);
  Future<void> deleteGood(Good good);
}

abstract class LocalizationPort {
  int getIntervalInDays(String interval);
}

abstract class TimePort {
  bool isDateBeforeDaysFromNow(String date, int days);
}
