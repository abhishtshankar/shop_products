import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartProduct {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  @JsonKey(name: 'discountPercentage')
  final double discount;
  @JsonKey(name: 'discountedPrice')
  final double discountedPrice;

  CartProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discount,
    required this.discountedPrice,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => _$CartProductFromJson(json);
  Map<String, dynamic> toJson() => _$CartProductToJson(this);
}

@JsonSerializable()
class Cart {
  final int id;
  final List<CartProduct> products;
  final int userId;
  final double total;

  Cart({
    required this.id,
    required this.products,
    required this.userId,
    required this.total,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}
