import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../auth/components/background.dart';
import '../../auth/components/text_field_container.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class ForgotPassword extends StatefulWidget {
  final Function forgetPassword;
  const ForgotPassword(this.forgetPassword, {Key? key}) : super(key: key);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  bool secureText = true;
  final _forgetpassKey = GlobalKey<FormFieldState>();
  bool _forgotpasswordLoading = false;
  String _email = "";

  void _submit(BuildContext ctx) async {
    bool isEmailVailed = _forgetpassKey.currentState!.validate();
    FocusScope.of(ctx).unfocus();
    if (isEmailVailed) {
      try {
        _forgetpassKey.currentState!.save();
        setState(() {
          _forgotpasswordLoading = true;
        });
        final auth = FirebaseAuth.instance;
        await auth.sendPasswordResetEmail(
            email: _email,
            actionCodeSettings: ActionCodeSettings(
                url:
                    "https://shopping-31c1b.firebaseapp.com/__/auth/action?mode=action&oobCode=code"));

        setState(() {
          _forgotpasswordLoading = false;
        });
        showDialog(
            barrierDismissible: false,
            context: ctx,
            builder: (ctx) => AlertDialog(
                  title: const Text("Reset password successfully sent"),
                  content: Text(
                      "We have sent url reset password to your email : $_email"),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(color: Colors.blue))),
                      child: const Text("Ok"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        setState(() {
                          widget.forgetPassword();
                        });
                      },
                    ),
                  ],
                ));
      } on FirebaseAuthException catch (e) {
        String message = "Unknow Error.";
        if (e.code == 'user-not-found') {
          message = "There is no account for this email in our system.";
        } else if (e.code == 'invalid-email') {
          message = "Email address is not correct.";
        } else if (e.code == 'network-request-failed') {
          message = 'network connection error.';
        } else {
          message = e.code.toString();
        }
        setState(() {
          _forgotpasswordLoading = false;
        });
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text(message),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      child: const Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      }
      _email = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Forget Password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),

            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),

            //Email
            TextFieldContainer(
              child: TextFormField(
                key: _forgetpassKey,
                decoration: const InputDecoration(
                  hintText: "Your Email",
                  icon: Icon(
                    Icons.alternate_email,
                    color: Color(0xFF09B07D),
                  ),
                  border: InputBorder.none,
                ),
                cursorColor: const Color(0xFF09B07D),
                onSaved: (fieldvalue) => _email = fieldvalue ?? '',
                validator: (val) {
                  if (val!.isEmpty || !val.contains("@")) {
                    return "Please enter a valid email adress";
                  }
                  return null;
                },
              ),
            ),
            if (_forgotpasswordLoading)
              SpinKitCircle(
                duration: const Duration(seconds: 2),
                color: Colors.lightBlue[300],
                size: 60,
              ),
            if (!_forgotpasswordLoading)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF09B07D))),
                    onPressed: () {
                      _submit(context);
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.03),
            if (!_forgotpasswordLoading)
              GestureDetector(
                onTap: () {
                  widget.forgetPassword();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.arrow_back,
                      color: Color(0xFF09B07D),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Back to Login",
                      style: TextStyle(
                        color: Color(0xFF09B07D),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
