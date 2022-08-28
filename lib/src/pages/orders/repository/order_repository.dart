import 'package:quitanda_virtual/src/constants/endpoints.dart';
import 'package:quitanda_virtual/src/services/http_manager.dart';

import '../../../models/order_model.dart';

class OrderRepository {
  final _httpManager = HttpManager();
  List<OrderModel> ordersList = [];

  Future<void> getAllOrders() async {
    await _httpManager.restRequest(
        url: EndPoints.checkout, method: HttpMethods.post);
  }
}
