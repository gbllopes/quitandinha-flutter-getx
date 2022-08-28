import 'dart:convert';

import 'package:quitanda_virtual/src/models/cart_item_model.dart';

class OrderModel {
  String id;
  DateTime? createdDateTime;
  DateTime overdueDateTime;
  List<CartItemModel> items;
  String status;
  String copyAndPaste;
  double total;
  String? qrCodeImage;

  OrderModel({
    required this.id,
    required this.createdDateTime,
    required this.overdueDateTime,
    this.items = const [],
    required this.status,
    required this.copyAndPaste,
    required this.total,
    this.qrCodeImage,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (createdDateTime != null) {
      result
          .addAll({'createdDateTime': createdDateTime!.millisecondsSinceEpoch});
    }
    result.addAll({'due': overdueDateTime.millisecondsSinceEpoch});
    result.addAll({'items': items.map((x) => x.toMap()).toList()});
    result.addAll({'status': status});
    result.addAll({'copiaecola': copyAndPaste});
    result.addAll({'total': total});
    if (qrCodeImage != null) {
      result.addAll({'qrCodeImage': qrCodeImage});
    }

    return result;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      createdDateTime: map['createdDateTime'] != null
          ? DateTime.parse(map['createdDateTime'] as String)
          : null,
      overdueDateTime: DateTime.parse(map['due'] as String),
      items: map['items'] != null
          ? List<CartItemModel>.from(
              map['items']?.map((x) => CartItemModel.fromMap(x)))
          : [],
      status: map['status'] ?? '',
      copyAndPaste: map['copiaecola'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
      qrCodeImage: map['qrCodeImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(id: $id, createdDateTime: $createdDateTime, overdueDateTime: $overdueDateTime, items: $items, status: $status, copyAndPaste: $copyAndPaste, total: $total, qrCodeImage: $qrCodeImage)';
  }
}
