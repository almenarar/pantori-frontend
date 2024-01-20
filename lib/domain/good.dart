import 'package:equatable/equatable.dart';

class Good  extends Equatable{
  final String id;
  final String name;
  final String category;
  final String buyDate;
  final String expirationDate;
  final String imagePath;

  const Good(
      {required this.id,
      required this.name,
      required this.category,
      required this.buyDate,
      required this.expirationDate,
      required this.imagePath});

  factory Good.fromJson(Map<String, dynamic> json) {
    return Good(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      buyDate: json['buy_date'] ?? '',
      expirationDate: json['expire'] ?? '',
      imagePath: json['image_url'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, name, category, buyDate, expirationDate, imagePath];
}
