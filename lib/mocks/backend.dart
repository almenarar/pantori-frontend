import 'package:pantori/domain/good.dart';
import 'package:pantori/domain/ports.dart';

class BackendMock implements BackendPort {
  @override
  Future<void> login(String user, String pwd) async {
    return;
  }

  @override
  Future<List<Good>> listGoods() async {
    return [
      Good(
          id: "foo",
          name: "carrot",
          category: "beans",
          buyDate: "30/11/2000",
          expirationDate: "30/02/2001",
          imagePath: "empty")
    ];
  }

  @override
  Future<void> createGood(Good good) async {
    return;
  }

  @override
  Future<void> deleteGood(Good good) async {
    return;
  }
}
