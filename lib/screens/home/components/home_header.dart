import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';

import '../../../screens/cart/cart_screen.dart';

import '../../../other/size_config.dart';
import 'cart_icon.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SearchField(),
          Selector<CartProvider, int>(
            selector: (ctx, value) => value.itemCount,
            builder: (ctx, itemsCount, _) => CartIcon(
              numOfitem: itemsCount,
              press: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
          // IconBtnWithCounter(
          //   svgSrc: "assets/icons/Bell.svg",
          //   numOfitem: 3,
          //   press: () {},
          // ),
        ],
      ),
    );
  }
}
