import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../other/models.dart';
import '../../../other/size_config.dart';
import '../../chat/widgets/friend_chat_screen.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20), vertical: 10),
          child: Text(
            product.productName,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            "\$${product.productPrice}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        if (product.creatorId != FirebaseAuth.instance.currentUser!.uid)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(7)),
              width: getProportionateScreenWidth(190),
              decoration: BoxDecoration(
                color: product.isFavorite
                    ? const Color(0xFFFFE6E6)
                    : const Color(0xFFF5F6F9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Seller Info",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => FriendScreen(
                              userName: product.creatorName,
                              imageUrl: product.creatorImageUrl,
                              userId: product.creatorId,
                              seen: 0,
                              isFromProduct: true,
                            ),
                          ),
                        );
                      },
                      icon: CircleAvatar(
                        backgroundImage: NetworkImage(product.creatorImageUrl),
                      ),
                      label: Text(product.creatorName)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => FriendScreen(
                              userName: product.creatorName,
                              imageUrl: product.creatorImageUrl,
                              userId: product.creatorId,
                              seen: 0,
                              isFromProduct: true,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Send a message',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(15),
            right: getProportionateScreenWidth(10),
          ),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: EdgeInsets.all(getProportionateScreenWidth(20)),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F6F9),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            height: 100,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    product.productDescription,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
