import 'package:flutter/material.dart';

import 'package:quitanda_virtual/src/config/app_data.dart';
import 'package:quitanda_virtual/src/models/cart_item_model.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';

import '../../../models/order_model.dart';
import '../../cart/components/order_status_widget.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  final UtilsServices utilsServices = UtilsServices();

  OrderTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Pedido ${order.id}'),
                Text(
                  utilsServices.formatDateTime(order.createdDateTime),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            children: [
              SizedBox(
                height: 150,
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: ListView(
                          children: order.items
                              .map((orderItem) => _OrderItemWidget(
                                  utilsServices: utilsServices,
                                  orderItem: orderItem))
                              .toList(),
                        )),
                    VerticalDivider(
                      color: Colors.grey[300],
                      thickness: 2,
                      width: 8,
                    ),
                    Expanded(
                        flex: 2,
                        child: OrderStatusWidget(
                          status: order.status,
                          isOverdue:
                              order.overdueDateTime.isBefore(DateTime.now()),
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class _OrderItemWidget extends StatelessWidget {
  final CartItemModel orderItem;

  const _OrderItemWidget({
    Key? key,
    required this.orderItem,
    required this.utilsServices,
  }) : super(key: key);

  final UtilsServices utilsServices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${orderItem.quantity} ${orderItem.item.unit} ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(orderItem.item.itemName)),
          Text(utilsServices.priceToCurrency(orderItem.totalPrice())),
        ],
      ),
    );
  }
}
