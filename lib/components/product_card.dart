import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../other/models.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

import '../screens/details/details_screen.dart';

import '../other/constants.dart';
import '../other/size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
    this.index, {
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);
  final int index;
  final double width, aspectRetio;
  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getProportionateScreenWidth(10),
          right: getProportionateScreenWidth(10)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => DetailsScreen(
                        product: product,
                      ))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor ==
                                Colors.white
                            ? Colors.black
                            : Colors.white,
                        width: 2,
                      )),
                  child: Hero(
                    tag: product.productId.toString(),
                    child: Image.network(product.productImageUrl),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                "${product.productName} \n",
                // style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.productPrice}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      int quantity =
                          Provider.of<CartProvider>(context, listen: false)
                              .addItem(
                                  product.productId,
                                  product.productImageUrl,
                                  product.productPrice,
                                  product.productName);

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${product.productName} Added to your Cart${quantity > 1 ? " x$quantity" : ""}",
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
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                      height: getProportionateScreenWidth(30),
                      width: getProportionateScreenWidth(30),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("assets/icons/Cart Icon.svg",
                          color: const Color(0xFFFF4848)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Provider.of<ProductProvider>(context, listen: false)
                          .changeItemFav(product.productId);
                    },
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                      height: getProportionateScreenWidth(30),
                      width: getProportionateScreenWidth(30),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: const Color(0xFFFF4848),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
