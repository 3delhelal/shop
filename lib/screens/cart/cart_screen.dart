import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (ctx, cartprov, _) => Scaffold(
              appBar: buildAppBar(context, cartprov.itemCount),
              body: Body(
                items: cartprov.items,
              ),
              bottomNavigationBar: CheckoutCard(
                totaleAmount: cartprov.totalAmount,
                items: cartprov.items,
              ),
            ));
  }

  AppBar buildAppBar(BuildContext context, int itemCount) {
    return AppBar(
      title: Column(
        children: [
          const Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "$itemCount items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
