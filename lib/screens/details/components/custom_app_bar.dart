import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../other/size_config.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({required super.child, required super.preferredSize});

  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(40),
              width: getProportionateScreenWidth(40),
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/Back ICon.svg",
                  height: 15,
                  color:
                      Theme.of(context).scaffoldBackgroundColor == Colors.white
                          ? Colors.black54
                          : Colors.white60,
                ),
              ),
            ),
            // Text(
            //   "Chat",
            //   style: Theme.of(context).textTheme.headline6,
            // )
          ],
        ),
      ),
    );
  }
}
