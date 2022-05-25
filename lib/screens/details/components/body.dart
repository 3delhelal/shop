import 'package:flutter/material.dart';

import './/other/models.dart';

import 'product_description.dart';

import 'product_images.dart';

class Body extends StatelessWidget {
  final ProductItem product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
        ProductDescription(
          product: product,
        ),
      ],
    );
  }
}
