import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './other/theme.dart';
import './providers/user_provider.dart';
import 'other/routes.dart';
import './screens/home/home_screen.dart';
import 'providers/products_provider.dart';
import './auth/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ProductProvider>(
      create: (ctx) => ProductProvider(),
    ),
    ChangeNotifierProvider<CartProvider>(
      create: (ctx) => CartProvider(),
    ),
    ChangeNotifierProvider<OrdersProvider>(
      create: (ctx) => OrdersProvider(),
    ),
    ChangeNotifierProvider<UserProvider>(
      create: (ctx) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop',
      themeMode: ThemeMode.light,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      routes: routes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            return HomeScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
