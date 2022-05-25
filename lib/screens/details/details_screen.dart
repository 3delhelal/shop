import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/other/models.dart';
import '/providers/cart_provider.dart';

import '../../other/size_config.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";
  final ProductItem? product;
  const DetailsScreen({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(child: Text(''), preferredSize: Size.zero),
      body: Body(product: product!),
      bottomNavigationBar: Container(
        constraints: BoxConstraints(
          minHeight: getProportionateScreenWidth(80),
          maxHeight: getProportionateScreenHeight(100),
        ),
        margin: EdgeInsets.only(bottom: getProportionateScreenWidth(10)),
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(15),
            horizontal: getProportionateScreenWidth(20)),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor == Colors.white
              ? Colors.grey.shade200
              : Colors.black45,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
              // maximumSize: MaterialStateProperty.all(Size(80, 80)),

              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
          onPressed: () {
            int quantity = Provider.of<CartProvider>(context, listen: false)
                .addItem(product!.productId, product!.productImageUrl,
                    product!.productPrice, product!.productName);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${product!.productName} Added to your Cart${quantity > 1 ? " x$quantity" : ""}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 1200),
                padding: const EdgeInsets.all(5),
                backgroundColor: Colors.green[200],
              ),
            );
          },
          child: const Text("Add to Cart"),
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final ProductItem product;

  ProductDetailsArguments({required this.product});
}
