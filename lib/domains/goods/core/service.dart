import 'package:pantori/domains/goods/core/ports.dart';
import 'package:pantori/domains/goods/core/good.dart';

class GoodService implements ServicePort {
  final BackendPort backend;
  final TimePort time;

  GoodService(this.backend, this.time);

  @override
  List<Good> filter(List<Good> goods, String category, String interval) {
    List<Good> output;

    output = goods.where((good) {
      bool categoryMatches = category == 'All' || good.categories.contains(category);
      bool dateMatches = interval == 'All' ||
          time.isDateBeforeDaysFromNow(
              good.expirationDate, _getIntervalInDays(interval));
      return categoryMatches && dateMatches;
    }).toList();

    return output;
  }

  @override
  List<String> listFilterIntervals() {
    return ['3 days', '1 week', '2 weeks', '1 month', '3 months'];
  }

  int _getIntervalInDays(String interval) {
    int factor = 0;
    int amount = 0;

    List<String> splitted = interval.split(" ");
    amount = int.parse(splitted[0]);
    if (splitted[1].startsWith("day")) {
      factor = 1;
    }
    if (splitted[1].startsWith("week")) {
      factor = 7;
    }
    if (splitted[1].startsWith("month")) {
      factor = 30;
    }

    return factor * amount;
  }

  @override
  Future<List<Good>> listGoods() async {
    return await backend.listGoods();
  }

  @override
  Future<void> createGood(Good good) async {
    await backend.createGood(good);
    return;
  }

  @override
  Future<void> replaceGood(Good good, String newExpireDate) async {
    Good newGood = Good(
      id: good.id, 
      name: good.name, 
      categories: good.categories, 
      buyDate: time.getTodaysDate(), 
      expirationDate: newExpireDate, 
      imagePath: good.imagePath,
      createdAt: ''
    );
    await backend.editGood(newGood);
    return;
  }

  @override
  Future<void> editGood(Good good) async {
    await backend.editGood(good);
    return;
  }

  @override
  Future<void> deleteGood(Good good) async {
    await backend.deleteGood(good);
    return;
  }
}
