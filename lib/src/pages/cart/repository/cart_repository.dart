import 'package:quitanda_virtual/src/models/order_model.dart';

import '../../../constants/endpoints.dart';
import '../../../models/cart_item_model.dart';
import '../../../services/http_manager.dart';
import '../result/cart_result.dart';

class CartRepository {
  final HttpManager _httpManager = HttpManager();

  Future<CartResult<List<CartItemModel>>> getCartItems(
      {required String token, required String userId}) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.getCartItems,
      method: HttpMethods.post,
      headers: {"X-Parse-Session-Token": token},
      body: {"user": userId},
    );

    if (result['result'] != null) {
      List<CartItemModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CartItemModel.fromMap)
              .toList();

      return CartResult<List<CartItemModel>>.success(data);
    } else {
      return CartResult.error(
          'Ocorreu um erro inesperado ao tentar recuperar os itens do carrinho.');
    }
  }

  Future<CartResult<String>> addItemsToCart({
    required String token,
    required String productId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.addItemToCart,
      method: HttpMethods.post,
      headers: {
        "X-Parse-Session-Token": token,
      },
      body: {
        "productId": productId,
        "quantity": quantity,
      },
    );
    if (result['result'] != null) {
      return CartResult<String>.success(result['result']['id']);
    } else {
      return CartResult.error(
          'Ocorreu um erro inesperado ao tentar adicionar o item ao carrinho.');
    }
  }

  Future<bool> changeItemQuantity({
    required String token,
    required int quantity,
    required String cartItemId,
  }) async {
    final result = await _httpManager.restRequest(
        url: EndPoints.changeItemQuantity,
        method: HttpMethods.post,
        headers: {
          "X-Parse-Session-Token": token,
        },
        body: {
          "cartItemId": cartItemId,
          "quantity": quantity
        });

    return result.isEmpty;
  }

  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total,
  }) async {
    final result = await _httpManager.restRequest(
        url: EndPoints.checkout,
        method: HttpMethods.post,
        headers: {
          "X-Parse-Session-Token": token,
        },
        body: {
          "total": total,
        });

    if (result['result'] != null) {
      final order = OrderModel.fromMap(result['result']);
      return CartResult<OrderModel>.success(order);
    } else {
      return CartResult.error('Não foi possível realizar o pedido');
    }
  }
}
