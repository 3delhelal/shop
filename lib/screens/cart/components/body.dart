import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';

import '../../../other/size_config.dart';
import 'cart_card.dart';

class Body extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final items;

  const Body({Key? key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(items.keys.toList()[index].toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              Provider.of<CartProvider>(context, listen: false)
                  .removeItem(items.keys.toList()[index]);
            },
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  SvgPicture.asset("assets/icons/Trash.svg"),
                ],
              ),
            ),
            child: CartCard(item: items.values.toList()[index]),
          ),
        ),
      ),
    );
  }
}
