import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_virtual/src/pages/base/controller/navigation_controller.dart';

import '../cart/cart_tab.dart';
import '../home/view/home_tab.dart';
import '../orders/orders_tab.dart';
import '../profile/profile_tab.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final navigationController = Get.find<NavigationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: navigationController.pageController,
        children: [
          const HomeTab(),
          CartTab(),
          const OrdersTab(),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            onTap: (index) {
              setState(() {
                navigationController.navigatePageView(index);
                // pageController.animateToPage(index,
                //     duration: const Duration(milliseconds: 500),
                //     curve: Curves.ease);
              });
            },
            currentIndex: navigationController.currentIndex,
            backgroundColor: Colors.green,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withAlpha(100),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Carrinho',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Pedidos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Perfil',
              )
            ],
          )),
    );
  }
}
