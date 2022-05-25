import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/user_provider.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/user_chats/user_chats.dart';
import '../../other/constants.dart';
import '../../other/enums.dart';
import '../../other/size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MenuState _selectedMenu = MenuState.home;
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).fechData();
    Provider.of<OrdersProvider>(context, listen: false).fechOrders();
    Provider.of<UserProvider>(context, listen: false).fechData();

    super.initState();
  }

  void starts() {
    FirebaseFirestore.instance
        .doc("userslist")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .add({"lastseen": FieldValue.serverTimestamp()});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(
        selectedMenu: _selectedMenu,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor == Colors.white
              ? Colors.white
              : kContentColorLightTheme,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 5,
              color: const Color(0xFFDADADA).withOpacity(0.15),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: _selectedMenu == MenuState.home
                        ? kPrimaryColor
                        : const Color(0xFFB6B6B6),
                  ),
                  onPressed: _selectedMenu == MenuState.home
                      ? null
                      : () {
                          setState(() {
                            _selectedMenu = MenuState.home;
                          });
                        },
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Heart Icon.svg",
                    color: _selectedMenu == MenuState.favourite
                        ? kPrimaryColor
                        : const Color(0xFFB6B6B6),
                  ),
                  onPressed: _selectedMenu == MenuState.favourite
                      ? null
                      : () {
                          setState(() {
                            _selectedMenu = MenuState.favourite;
                          });
                        },
                ),
                chatIcon(UserProvider.fireStoreInstance
                    .collection(UserProvider.fireAuthInstance.currentUser!.uid)
                    .doc("chatfield")
                    .collection("chats")
                    .snapshots()),
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color: _selectedMenu == MenuState.profile
                        ? kPrimaryColor
                        : const Color(0xFFB6B6B6),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, ProfileScreen.routeName),
                ),
              ],
            )),
      ),
    );
  }

  // Icon Chat and her function
  Widget chatIcon(Stream<QuerySnapshot> str) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () => Navigator.pushNamed(context, MyChat.routeName),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            height: getProportionateScreenWidth(46),
            width: getProportionateScreenWidth(46),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor == Colors.white
                  ? Colors.white
                  : kContentColorLightTheme,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
          ),
          StreamBuilder(
            stream: str,
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              if (snapShot.data!.docs.where((element) {
                var data = element.data() as Map;
                return data["messagelength"] != data["seen"];
              }).isEmpty) {
                return const SizedBox();
              }
              return Positioned(
                top: -3,
                right: 0,
                child: Container(
                  height: getProportionateScreenWidth(18),
                  width: getProportionateScreenWidth(18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4848),
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.5, color: Colors.white),
                  ),
                  child: Text(
                    "${snapShot.data!.docs.where((element) {
                      var data = element.data() as Map;
                      return data["messagelength"] != data["seen"];
                    }).length}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
