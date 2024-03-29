import 'package:get/get.dart';
import 'package:quitanda_virtual/src/models/item_model.dart';
import 'package:quitanda_virtual/src/pages/home/repository/home_repository.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';

import '../../../models/category_model.dart';
import '../result/home_result.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final utilsServices = UtilsServices();
  final homeRepository = HomeRepository();
  bool isCategoryLoading = false;
  bool isProductLoading = true;

  RxString searchTitle = ''.obs;

  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  bool get isLastPage {
    if (currentCategory!.items.length < itemsPerPage) return true;
    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();

    debounce(
      searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );

    getAllCategories();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
    if (currentCategory!.items.isNotEmpty) return;
    getAllProducts();
  }

  loadMoreProducts() {
    currentCategory!.pagination++;
    getAllProducts(canLoad: false);
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    update();
  }

  void filterByTitle() {
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');
      if (c == null) {
        final allCategory =
            CategoryModel(title: 'Todos', id: '', pagination: 0, items: []);
        allCategories.insert(0, allCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }

    currentCategory = allCategories.first;
    update();
    getAllProducts();
  }

  Future<void> getAllCategories() async {
    setLoading(true);

    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();

    setLoading(false);

    homeResult.when(success: (data) {
      allCategories.assignAll(data);
      if (allCategories.isNotEmpty) {
        selectCategory(allCategories.first);
      }
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }

    Map<String, dynamic> body = {
      "page": currentCategory!.pagination,
      "categoryId": currentCategory!.id,
      "itemsPerPage": itemsPerPage
    };

    if (searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;
      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }

    HomeResult<ItemModel> homeResult =
        await homeRepository.getAllProducts(body);

    setLoading(false, isProduct: true);

    homeResult.when(success: (data) {
      currentCategory!.items.addAll(data);
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
  }
}
