import 'package:flutter/material.dart';

import '../other/constants.dart';
import '../other/size_config.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  _DefaultButtonState createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: double.infinity,
            height: getProportionateScreenHeight(56),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(color: kPrimaryColor)),
              ),
              onPressed: () async {
                setState(() => _isLoading = true);
                widget.press();
                setState(() {
                  setState(() => _isLoading = false);
                });
              },
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                ),
              ),
            ),
          );
  }
}
