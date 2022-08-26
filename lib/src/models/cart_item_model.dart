import 'dart:convert';

import 'item_model.dart';

class CartItemModel {
  String? id;
  ItemModel item;
  int quantity;

  CartItemModel({
    this.id,
    required this.item,
    required this.quantity,
  });

  double totalPrice() => item.price * quantity;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'product': item.toMap()});
    result.addAll({'quantity': quantity});

    return result;
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] ?? '',
      item: ItemModel.fromMap(map['product']),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));
}
