import 'package:equatable/equatable.dart';

class Good extends Equatable {
  final String id;
  final String name;
  final List<String> categories;
  final String buyDate;
  final String expirationDate;
  final String imagePath;
  final String createdAt;

  const Good(
      {required this.id,
      required this.name,
      required this.categories,
      required this.buyDate,
      required this.expirationDate,
      required this.imagePath,
      required this.createdAt});

  factory Good.fromJson(Map<String, dynamic> json) {
    //final id = json['ID'];
    //if (id is! String) {
    //  throw FormatException(
    //    'Invalid JSON: required "ID" field of type String in $json'
    //  );
    //}

    final categories = json['Categories'] as List<dynamic>;

    return Good(
      id: json['ID'] as String,
      name: json['Name'] as String,
      categories: List<String>.from(categories),
      buyDate: json['BuyDate'] as String,
      expirationDate: json['Expire'] as String,
      imagePath: json['ImageURL'] as String,
      createdAt: json['CreatedAt'] as String,
    );
  }

  @override
  List<Object> get props =>
      [id, name, categories, buyDate, expirationDate, imagePath];
}
