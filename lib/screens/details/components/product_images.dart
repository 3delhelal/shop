import 'package:flutter/material.dart';
import '../../../other/models.dart';

import '../../../other/size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductItem product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor == Colors.white
                    ? Colors.black
                    : Colors.white,
              )),
          width: getProportionateScreenWidth(
              MediaQuery.of(context).size.width / 1.7),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.product.productId.toString(),
              child: Image.network(
                widget.product.productImageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
