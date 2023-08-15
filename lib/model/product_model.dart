import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  @JsonKey(name: 'discountPercentage')
  final double discount;
  final String thumbnail;
  final List<String> images;
  bool isFavorite;


  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discount,
    required this.thumbnail,
    required this.images,
    this.isFavorite = false,

  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
