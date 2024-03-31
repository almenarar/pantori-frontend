import 'package:pantori/domain/good.dart';

class TestInputs {
  static const Good defaultGood = Good(
    id: "",
    name: "good1",
    categories: ["foo", "bar"],
    buyDate: "00/00/0000",
    expirationDate: "2045-12-30T00:00:00Z",
    imagePath: "",
    createdAt: ""
  );

  static const List<Good> defaultInputGoodList = [
    Good(
      id: "",
      name: "good1",
      categories: ["foo", "bar"],
      buyDate: "00/00/0000",
      expirationDate: "2045-12-30T00:00:00Z",
      imagePath: "",
      createdAt: ""
    ),
    Good(
      id: "",
      name: "good2",
      categories: ["bar"],
      buyDate: "00/00/0000",
      expirationDate: "2045-12-30T00:00:00Z",
      imagePath: "",
      createdAt: ""
    ),
    Good(
      id: "",
      name: "good3",
      categories: ["afar","foo"],
      buyDate: "00/00/0000",
      expirationDate: "2045-12-10T00:00:00Z",
      imagePath: "",
      createdAt: ""
    ),
    Good(
      id: "",
      name: "good4",
      categories: ["zap", "zoon"],
      buyDate: "00/00/0000",
      expirationDate: "2045-12-10T00:00:00Z",
      imagePath: "",
      createdAt: ""
    ),
  ];
}
