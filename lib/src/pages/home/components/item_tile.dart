import 'package:flutter/material.dart';

import 'package:quitanda_virtual/src/pages/products/product_screen.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';

import '../../../config/custom_colors.dart';
import '../../../models/item_model.dart';

class ItemTile extends StatefulWidget {
  final ItemModel item;
  final void Function(GlobalKey) cartAnimationMethod;

  ItemTile({
    Key? key,
    required this.item,
    required this.cartAnimationMethod,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final UtilsServices utilsServices = UtilsServices();
  final GlobalKey imageGk = GlobalKey();
  IconData tileIcon = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(() => tileIcon = Icons.check);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => tileIcon = Icons.add_shopping_cart_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductScreen(item: widget.item)));
          },
          child: Card(
            elevation: 2,
            shadowColor: Colors.grey.shade300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Hero(
                    tag: widget.item.imgUrl,
                    child: Image.asset(
                      widget.item.imgUrl,
                      key: imageGk,
                    ),
                  )),
                  Text(widget.item.itemName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(utilsServices.priceToCurrency(widget.item.price),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.customSwatchColor)),
                      Text(widget.item.unit,
                          style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                              fontSize: 12))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(20),
            ),
            child: Material(
              child: InkWell(
                onTap: () {
                  switchIcon();
                  widget.cartAnimationMethod(imageGk);
                },
                child: Ink(
                  height: 45,
                  width: 35,
                  decoration: BoxDecoration(
                    color: CustomColors.customSwatchColor,
                  ),
                  child: Icon(
                    tileIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
