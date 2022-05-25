import 'package:flutter/widgets.dart';
import '../screens/edit_product/edit_product_screen.dart';
import '../screens/manage_products/manage_product_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/update_profile/update_profile_screen.dart';
import '../screens/user_chats/user_chats.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/details/details_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  OrderScreen.routeName: (context) => const OrderScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  UpdateProfile.routeName: (context) => const UpdateProfile(),
  ManageProducts.routeName: (context) => const ManageProducts(),
  EditProductScreen.routeName: (context) => const EditProductScreen(),
  MyChat.routeName: (context) => MyChat(),
};
