import 'package:quitanda_virtual/src/constants/endpoints.dart';
import 'package:quitanda_virtual/src/models/item_model.dart';
import 'package:quitanda_virtual/src/pages/home/result/home_result.dart';

import '../../../models/category_model.dart';
import '../../../services/http_manager.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await _httpManager.restRequest(
        url: EndPoints.getAllCategories, method: HttpMethods.post);

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromMap)
              .toList();
      return HomeResult<CategoryModel>.success(data);
    } else {
      return HomeResult.error(
          'Ocorreu um erro inesperado ao tentar recuperar as categorias.');
    }
  }

  Future<HomeResult<ItemModel>> getAllProducts(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.getAllProducts,
      method: HttpMethods.post,
      body: body,
    );

    if (result['result'] != null) {
      List<ItemModel> data = (List<Map<String, dynamic>>.from(result['result']))
          .map(ItemModel.fromMap)
          .toList();

      return HomeResult<ItemModel>.success(data);
    } else {
      return HomeResult.error(
          'Ocorreu um erro inesperado ao tentar recuperar os itens.');
    }
  }
}
