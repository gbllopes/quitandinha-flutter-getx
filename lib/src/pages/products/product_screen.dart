import 'package:flutter/material.dart';
import 'package:quitanda_virtual/src/config/custom_colors.dart';
import 'package:quitanda_virtual/src/servives/utils_services.dart';

import '../../models/item_model.dart';
import '../common_widgets/quantity_widget.dart';

class ProductScreen extends StatelessWidget {
  ItemModel item;
  final UtilsServices utilsServices = UtilsServices();
  int cartItemQuantity = 1;

  ProductScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Hero(
                  tag: item.imgUrl,
                  child: Image.asset(item.imgUrl),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          offset: const Offset(0, 2),
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.itemName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                          QuantityWidget(
                            unit: item.unit,
                            quantity: cartItemQuantity,
                            result: (quantity) {
                              cartItemQuantity = quantity;
                            },
                          )
                        ],
                      ),
                      Text(utilsServices.priceToCurrency(item.price),
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.customSwatchColor)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SingleChildScrollView(
                            child: Text(item.description,
                                style: const TextStyle(
                                  height: 1.5,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                          label: const Text('Add ao carrinho',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          )
        ],
      ),
    );
  }
}
