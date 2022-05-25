import 'package:flutter/material.dart';

import '../../../other/constants.dart';

class MenuListTile extends StatelessWidget {
  const MenuListTile({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: kPrimaryColor,
      ),
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: GestureDetector(
        onTap: press,
        child: const Text("Edit", style: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }
}
