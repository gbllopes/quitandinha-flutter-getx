import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_virtual/src/config/custom_colors.dart';
import 'package:quitanda_virtual/src/pages/base/controller/navigation_controller.dart';
import 'package:quitanda_virtual/src/pages/cart/controller/cart_controller.dart';
import 'package:quitanda_virtual/src/pages/common_widgets/custom_shimmer.dart';
import 'package:quitanda_virtual/src/pages/home/controller/home_controller.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';

import '../../common_widgets/app_name_widget.dart';
import '../components/category_tile.dart';
import '../components/item_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _searchController = TextEditingController();
  final UtilsServices utilsServices = UtilsServices();
  final navigationController = Get.find<NavigationController>();

  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCardAnimation;

  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCardAnimation(gkImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: GestureDetector(
              onTap: () {
                navigationController.navigatePageView(NavigationTabs.cart);
              },
              child: GetBuilder<CartController>(
                builder: (cartController) {
                  return Badge(
                      badgeContent: Text(
                        cartController.cartItems.length.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      badgeColor: CustomColors.customConstrastColor,
                      child: AddToCartIcon(
                        key: globalKeyCartItems,
                        icon: Icon(Icons.shopping_cart,
                            color: CustomColors.customSwatchColor),
                      ));
                },
              ),
            ),
          )
        ],
      ),
      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCartAnimationMethod) {
          runAddToCardAnimation = addToCartAnimationMethod;
        },
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GetBuilder<HomeController>(
                  builder: (controller) => TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                      suffixIcon: controller.searchTitle.value.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                controller.searchTitle.value = '';
                                FocusScope.of(context).unfocus();
                              },
                              icon: const Icon(Icons.close),
                              color: Colors.red,
                              iconSize: 21,
                            )
                          : null,
                      hintText: 'Pesquisa aqui...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.customConstrastColor,
                        size: 21,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                )),
            GetBuilder<HomeController>(builder: (controller) {
              return Container(
                padding: const EdgeInsets.only(left: 25),
                height: 40,
                child: !controller.isCategoryLoading
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, idx) => CategoryTile(
                              onPressed: () {
                                setState(() {
                                  controller.selectCategory(
                                      controller.allCategories[idx]);
                                });
                              },
                              category: controller.allCategories[idx].title,
                              isSelected: controller.currentCategory ==
                                      controller.allCategories[idx]
                                  ? true
                                  : false,
                            ),
                        separatorBuilder: (_, idx) => const SizedBox(width: 10),
                        itemCount: controller.allCategories.length)
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          7,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 12),
                            alignment: Alignment.center,
                            child: CustomShimmer(
                              height: 20,
                              width: 80,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
              );
            }),
            GetBuilder<HomeController>(
                builder: (controller) => Expanded(
                      child: !controller.isProductLoading
                          ? Visibility(
                              visible: (controller.currentCategory?.items ?? [])
                                  .isNotEmpty,
                              replacement: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 40,
                                    color: CustomColors.customSwatchColor,
                                  ),
                                  const Text('Não há itens para apresentar')
                                ],
                              ),
                              child: GridView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 9 / 11.5,
                                  ),
                                  itemCount: controller.allProducts.length,
                                  itemBuilder: (_, idx) {
                                    if (((idx + 1) ==
                                            controller.allProducts.length) &&
                                        !controller.isLastPage) {
                                      controller.loadMoreProducts();
                                    }
                                    return ItemTile(
                                      item: controller.allProducts[idx],
                                      cartAnimationMethod:
                                          itemSelectedCartAnimations,
                                    );
                                  }),
                            )
                          : GridView.count(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              physics: const BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 9 / 11.5,
                              children: List.generate(
                                10,
                                (index) => CustomShimmer(
                                  borderRadius: BorderRadius.circular(20),
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                    )),
          ],
        ),
      ),
    );
  }
}
