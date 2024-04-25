import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String color;

  const Category({
    required this.id,
    required this.color,
    required this.name
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['ID'] as String,
      color: json['Color'] as String,
      name: json['Name']
    );
  }

  @override
  List<Object> get props => [id, name, color];
}