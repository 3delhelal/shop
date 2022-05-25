import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/components/rounded_icon_btn.dart';
import '/other/models.dart';
import '/providers/cart_provider.dart';

import '../../../other/constants.dart';
import '../../../other/size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.black26,
                  width: 2,
                ),
              ),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "\$${item.price}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                children: const [
                  // TextSpan(
                  //     text: " x${item.quantity}",
                  //     style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        RoundedIconBtn(
          icon: Icons.remove,
          press: () {
            Provider.of<CartProvider>(context, listen: false)
                .removeSingleItem(item.itemId);
          },
        ),
        SizedBox(width: getProportionateScreenWidth(10)),
        Text(item.quantity.toString()),
        SizedBox(width: getProportionateScreenWidth(10)),
        RoundedIconBtn(
          icon: Icons.add,
          showShadow: true,
          press: () {
            Provider.of<CartProvider>(context, listen: false)
                .addItem(item.itemId, item.imageUrl, item.price, item.title);
          },
        ),
      ],
    );
  }
}
