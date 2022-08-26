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

  Future<void> addItemsToCart({
    required String token,
    required CartItemModel item,
  }) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.addItemToCart,
      method: HttpMethods.post,
      headers: {
        "X-Parse-Session-Token": token,
      },
      body: {
        "productId": item.id,
        "quantity": item.quantity,
      },
    );
  }
}
