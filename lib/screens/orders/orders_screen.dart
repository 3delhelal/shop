import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/orders_provider.dart';
import '/screens/orders/components/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';

  const OrderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Order"),
        ),
        body: Consumer<OrdersProvider>(
          builder: (ctx, orderData, child) => ListView.builder(
              itemCount: orderData.ordersList.length,
              itemBuilder: (BuildContext context, int index) {
                if (orderData.dataLoaded == false) {
                  return const CircularProgressIndicator();
                }
                return OrderWidget(orderData.ordersList[index]);
              }),
        ));
  }
}
