import 'dart:convert';

import 'item_model.dart';

class CategoryModel {
  String title;
  String id;
  int pagination;

  List<ItemModel> items;

  CategoryModel({
    required this.title,
    required this.id,
    required this.pagination,
    required this.items,
  });

  @override
  String toString() {
    return 'CategoryModel(title: $title, id: $id, pagination: $pagination, items: $items)';
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'id': id});
    result.addAll({'items': items.map((x) => x.toMap()).toList()});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
        title: map['title'] ?? '',
        id: map['id'] ?? '',
        items: map['items'] != null
            ? List<ItemModel>.from(
                map['items']?.map((x) => ItemModel.fromMap(x)))
            : [],
        pagination: map['pagination'] ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));
}
