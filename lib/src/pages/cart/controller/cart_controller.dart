import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_virtual/src/models/order_model.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';

import '../../../models/cart_item_model.dart';
import '../../../models/item_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../common_widgets/payment_dialog.dart';
import '../repository/cart_repository.dart';
import '../result/cart_result.dart';

class CartController extends GetxController {
  bool isCheckoutLoading = false;
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();

  final utilsServices = UtilsServices();

  final List<CartItemModel> cartItems = [];
  @override
  void onInit() {
    super.onInit();

    getCartItems();
  }

  void setCheckoutLoading(bool value) {
    isCheckoutLoading = value;
    update();
  }

  Future<void> checkoutCart({required double total}) async {
    setCheckoutLoading(true);
    CartResult<OrderModel> result = await cartRepository.checkoutCart(
      token: authController.user.token!,
      total: total,
    );
    setCheckoutLoading(false);

    result.when(success: (order) {
      cartItems.clear();
      update();
      showDialog(
        context: Get.context!,
        builder: (_) => PaymentDialog(
          order: order,
        ),
      );
    }, error: (message) {
      utilsServices.showToast(message: message);
    });
  }

  Future<bool> changeItemQuantity({
    required CartItemModel cart,
    required int cartItemQuantity,
  }) async {
    final result = await cartRepository.changeItemQuantity(
      token: authController.user.token!,
      quantity: cartItemQuantity,
      cartItemId: cart.id!,
    );

    if (result) {
      if (cartItemQuantity == 0) {
        cartItems.removeWhere((cartItem) => cartItem.id == cart.id);
      } else {
        cartItems.firstWhere((cartItem) => cartItem.id == cart.id).quantity =
            cartItemQuantity;
      }
      update();
    } else {
      utilsServices.showToast(
          message: "Ocorreu um erro ao alterar a quantidade do produto.",
          isError: true);
    }
    return result;
  }

  Future<void> getCartItems() async {
    final cartResult = await cartRepository.getCartItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    cartResult.when(success: (data) {
      cartItems.assignAll(data);
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item.id == item.id);
  }

  Future<void> addItemsToCart({
    required ItemModel item,
    int quantity = 1,
  }) async {
    final cartResult = await cartRepository.getCartItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    int itemIndex = getItemIndex(item);

    if (itemIndex >= 0) {
      final product = cartItems[itemIndex];
      final result = await changeItemQuantity(
          cart: product, cartItemQuantity: (product.quantity + quantity));
    } else {
      final CartResult<String> result = await cartRepository.addItemsToCart(
        token: authController.user.token!,
        productId: item.id!,
        quantity: quantity,
      );

      result.when(success: (cartItemId) {
        cartItems
            .add(CartItemModel(id: cartItemId, item: item, quantity: quantity));
      }, error: (message) {
        utilsServices.showToast(message: message, isError: true);
      });
    }
    update();
  }

  double cartTotalPrice() {
    double total = 0;
    for (final item in cartItems) {
      total += item.totalPrice();
    }
    return total;
  }
}
