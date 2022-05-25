import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../screens/manage_products/manage_product_screen.dart';
import '../../../screens/orders/orders_screen.dart';
import '../../../screens/update_profile/update_profile_screen.dart';

import 'profile_menu.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Consumer<UserProvider>(
            builder: (ctx, userProv, _) {
              if (!userProv.dataLoaded) {
                return const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/whitephoto.jpg"),
                  minRadius: 50,
                  maxRadius: 65,
                );
              } else {
                return CircleAvatar(
                  backgroundImage: NetworkImage(userProv.userImageUrl!),
                  minRadius: 50,
                  maxRadius: 65,
                );
              }
            },
          ),
          const SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: Icons.person_outline,
            press: () =>
                Navigator.of(context).pushNamed(UpdateProfile.routeName),
          ),
          ProfileMenu(
            text: "Manage Products",
            icon: Icons.edit_outlined,
            press: () => Navigator.pushNamed(context, ManageProducts.routeName),
          ),
          ProfileMenu(
            text: "My Orders",
            icon: Icons.credit_card_outlined,
            press: () => Navigator.pushNamed(context, OrderScreen.routeName),
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icons.login_outlined,
            press: () {
              Provider.of<ProductProvider>(context, listen: false).clearData();
              Provider.of<UserProvider>(context, listen: false).clearData();
              Provider.of<OrdersProvider>(context, listen: false).clearOrders();
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.of(context).pop();
              UserProvider.fireAuthInstance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
