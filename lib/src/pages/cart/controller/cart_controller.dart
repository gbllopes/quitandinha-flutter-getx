import 'package:get/get.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';

import '../../../models/cart_item_model.dart';
import '../../../models/item_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/cart_repository.dart';

class CartController extends GetxController {
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();

  final utilsServices = UtilsServices();

  final List<CartItemModel> cartItems = [];
  @override
  void onInit() {
    super.onInit();

    getCartItems();
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
    return cartItems.indexWhere((itemInList) => itemInList.id == item.id);
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
      cartItems[itemIndex].quantity += quantity;
    } else {
      cartItems.add(CartItemModel(id: '', item: item, quantity: quantity));
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
