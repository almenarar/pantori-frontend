import 'package:equatable/equatable.dart';

class Good extends Equatable {
  final String id;
  final String name;
  final String category;
  final String buyDate;
  final String expirationDate;
  final String imagePath;
  final String createdAt;

  const Good(
      {required this.id,
      required this.name,
      required this.category,
      required this.buyDate,
      required this.expirationDate,
      required this.imagePath,
      required this.createdAt});

  factory Good.fromJson(Map<String, dynamic> json) {
    return Good(
      id: json['ID'] ?? '',
      name: json['Name'] ?? '',
      category: json['Category'] ?? '',
      buyDate: json['BuyDate'] ?? '',
      expirationDate: json['Expire'] ?? '',
      imagePath: json['ImageURL'] ?? '',
      createdAt: json['CreatedAt'] ?? '',
    );
  }

  @override
  List<Object> get props =>
      [id, name, category, buyDate, expirationDate, imagePath];
}
