import 'good.dart';

abstract class ServicePort {
  List<Good> filter(List<Good> goods, String category, String interval);
  List<String> listFilterIntervals();
  Future<List<Good>> listGoods();
  Future<void> createGood(Good good);
  Future<void> replaceGood(Good good, String newExpireDate);
  Future<void> editGood(Good good);
  Future<void> deleteGood(Good good);
}

abstract class BackendPort {
  void init(bool isProduction);
  Future<List<Good>> listGoods();
  Future<void> createGood(Good good);
  Future<void> editGood(Good good);
  Future<void> deleteGood(Good good);
}

abstract class LocalStoragePort {
  Future<void> init();
  Future<String> getString(String key);
}

abstract class LocalizationPort {
  int getIntervalInDays(String interval);
}

abstract class TimePort {
  bool isDateBeforeDaysFromNow(String date, int days);
  String getTodaysDate();
}
