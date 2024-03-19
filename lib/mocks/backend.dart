import 'package:pantori/domain/good.dart';
import 'package:pantori/domain/ports.dart';

class BackendMock implements BackendPort {
  bool createGoodInvoked = false;
  bool editGoodInvoked = false;
  bool deleteGoodInvoked = false;
  bool listGoodsInvoked = false;
  bool loginInvoked = false;

  @override
  void init(bool isLocal) {}

  @override
  Future<void> login(String user, String pwd) async {
    loginInvoked = true;
    return;
  }

  @override
  Future<List<Good>> listGoods() async {
    listGoodsInvoked = true;
    return const [
      Good(
          id: "foo",
          name: "carrot",
          category: "beans",
          buyDate: "30/11/2000",
          expirationDate: "30/02/2001",
          imagePath: "empty",
          createdAt: "08/2020"
        )
    ];
  }

  @override
  Future<void> createGood(Good good) async {
    createGoodInvoked = true;
    return;
  }

  @override
  Future<void> editGood(Good good) async {
    editGoodInvoked = true;
    return;
  }

  @override
  Future<void> deleteGood(Good good) async {
    deleteGoodInvoked = true;
    return;
  }
}
