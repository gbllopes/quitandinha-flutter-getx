import 'package:flutter/material.dart';
import 'package:quitanda_virtual/src/config/app_data.dart' as app_data;

import '../components/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus pedidos')),
      body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, idx) => OrderTile(
                order: app_data.orders[idx],
              ),
          separatorBuilder: (_, idx) => const SizedBox(height: 10),
          itemCount: app_data.orders.length),
    );
  }
}
