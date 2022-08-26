import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_virtual/src/config/custom_colors.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';
import 'package:quitanda_virtual/src/config/app_data.dart' as app_data;

import '../../common_widgets/payment_dialog.dart';
import '../components/cart_tile.dart';
import '../controller/cart_controller.dart';

class CartTab extends StatefulWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<CartController>(
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (_, idx) => CartTile(
                    cartItem: controller.cartItems[idx],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 3, spreadRadius: 2)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total geral',
                  style: TextStyle(fontSize: 12),
                ),
                GetBuilder<CartController>(
                  builder: (controller) {
                    return Text(
                      utilsServices
                          .priceToCurrency(controller.cartTotalPrice()),
                      style: TextStyle(
                          fontSize: 23,
                          color: CustomColors.customSwatchColor,
                          fontWeight: FontWeight.bold),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          primary: CustomColors.customSwatchColor),
                      onPressed: () async {
                        bool? result = await showOrderConfirmation();
                        if (result ?? false) {
                          showDialog(
                            context: context,
                            builder: (_) => PaymentDialog(
                              order: app_data.orders.first,
                            ),
                          );
                        } else {
                          utilsServices.showToast(
                              message: 'Pedido não confirmado', isError: true);
                        }
                      },
                      child: const Text(
                        'Concluir pedido',
                        style: TextStyle(fontSize: 18),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Confirmação'),
              content: const Text('Deseja realmente concluir o pedido?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Não'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Sim'),
                )
              ],
            ));
  }
}
