import 'package:pantori/domain/good.dart';

class TestInputs {
  static const Good defaultGood = Good(
      id: "",
      name: "good1",
      category: "foo",
      buyDate: "00/00/0000",
      expirationDate: "2045-12-30T00:00:00Z",
      imagePath: "");

  static const List<Good> defaultInputGoodList = [
    Good(
        id: "",
        name: "good1",
        category: "foo",
        buyDate: "00/00/0000",
        expirationDate: "2045-12-30T00:00:00Z",
        imagePath: ""),
    Good(
        id: "",
        name: "good2",
        category: "bar",
        buyDate: "00/00/0000",
        expirationDate: "2045-12-30T00:00:00Z",
        imagePath: ""),
    Good(
        id: "",
        name: "good3",
        category: "foo",
        buyDate: "00/00/0000",
        expirationDate: "2045-12-10T00:00:00Z",
        imagePath: ""),
    Good(
        id: "",
        name: "good4",
        category: "zap",
        buyDate: "00/00/0000",
        expirationDate: "2045-12-10T00:00:00Z",
        imagePath: ""),
  ];
}
