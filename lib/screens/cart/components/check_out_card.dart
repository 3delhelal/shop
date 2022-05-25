import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../other/constants.dart';
import '../../../other/models.dart';
import '../../../other/size_config.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard(
      {Key? key, required this.totaleAmount, required this.items})
      : super(key: key);
  final double totaleAmount;
  final Map<String, CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                text: "Total:\n",
                children: [
                  TextSpan(
                    text:
                        "\$ ${Provider.of<CartProvider>(context).totalAmount}",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Selector<OrdersProvider, bool>(
                selector: (ctx, orderprovider) => orderprovider.dataLoaded,
                builder: (ctx, value, _) {
                  return !value
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: getProportionateScreenHeight(56),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              textStyle: MaterialStateProperty.all(
                                  const TextStyle(color: kPrimaryColor)),
                            ),
                            onPressed: totaleAmount == 0
                                ? null
                                : () async {
                                    await Provider.of<OrdersProvider>(context,
                                            listen: false)
                                        .uploadOrder(items, totaleAmount);
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .clearCart();
                                  },
                            child: Text(
                              "Check Out",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                }),
          ],
        ),
      ),
    );
  }
}
