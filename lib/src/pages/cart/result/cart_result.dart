import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/cart_item_model.dart';

part 'cart_result.freezed.dart';

@freezed
class CartResult<T> with _$CartResult<T> {
  factory CartResult.success(T data) = Success;
  factory CartResult.error(String message) = Error;
}
