import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import '../../auth/components/background.dart';

import 'text_field_container.dart';

enum LogState { logIn, signUp }

class LogScreen extends StatefulWidget {
  final Function forgetPassword;
  final Function sumbitAuth;
  final bool isloading;
  const LogScreen(
    this.forgetPassword,
    this.sumbitAuth,
    this.isloading,
  );

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  LogState logstate = LogState.logIn;
  bool secureText = true;
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _username = "";

  void _submitLog() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.sumbitAuth(_email.trim(), _password.trim(), _username.trim(),
          logstate == LogState.logIn, context);
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
            SizedBox(height: size.height * 0.02),
            Text(
              logstate == LogState.logIn ? "LOGIN" : "SIGNUP",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.02),
            if (logstate == LogState.logIn)
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.30,
              ),

            SizedBox(height: size.height * 0.02),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //Email
                  TextFieldContainer(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "E-mail",
                          hintText: "Email",
                          icon: Icon(
                            Icons.alternate_email,
                            color: Color(0xFF09B07D),
                          ),
                          border: InputBorder.none),
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
                  //UserName
                  if (logstate != LogState.logIn)
                    TextFieldContainer(
                      child: TextFormField(
                        key: const ValueKey("UserName"),
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: "Username",
                          icon: Icon(
                            Icons.person,
                            color: Color(0xFF09B07D),
                          ),
                          border: InputBorder.none,
                        ),
                        cursorColor: const Color(0xFF09B07D),
                        onSaved: (fieldvalue) => _username = fieldvalue ?? '',
                        validator: (val) {
                          if (val!.isEmpty || val.length < 4) {
                            return "Please enter at least 4 characters";
                          }
                          if (val.isEmpty || val.length > 16) {
                            return "username maximum characters is 16";
                          }

                          return null;
                        },
                      ),
                    ),
                  //Password
                  TextFieldContainer(
                    child: TextFormField(
                      key: const ValueKey("Password"),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                        icon: const Icon(
                          Icons.lock,
                          color: Color(0xFF09B07D),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(secureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: const Color(0xFF09B07D),
                          onPressed: () {
                            setState(() {
                              secureText = !secureText;
                            });
                          },
                        ),
                        border: InputBorder.none,
                      ),
                      cursorColor: const Color(0xFF09B07D),
                      obscureText: secureText,
                      onChanged: (fieldvalue) => _password = fieldvalue,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                  ),

                  //Confirm Password
                  if (logstate != LogState.logIn)
                    TextFieldContainer(
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          hintText: "Confirm Password",
                          border: InputBorder.none,
                        ),
                        obscureText: secureText,
                        validator: (val) {
                          if (_password != val) {
                            return "Confirm password do not match";
                          }
                          return null;
                        },
                        cursorColor: const Color(0xFF09B07D),
                      ),
                    ),
                ],
              ),
            ),

            if (widget.isloading)
              SpinKitCircle(
                duration: const Duration(seconds: 2),
                color: Colors.lightBlue[300],
                size: 60,
              ),
            if (!widget.isloading)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF09B07D)),
                    ),
                    onPressed: () {
                      _submitLog();
                    },
                    child: Text(
                      logstate == LogState.logIn ? "LOGIN" : "SIGNUP",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.02),
            if (!widget.isloading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    logstate == LogState.logIn
                        ? "Don’t have an Account ? "
                        : "Already have an Account ? ",
                    style: const TextStyle(color: Color(0xFF09B07D)),
                  ),
                  if (!widget.isloading)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (logstate == LogState.logIn) {
                            logstate = LogState.signUp;
                          } else {
                            logstate = LogState.logIn;
                          }
                        });
                      },
                      child: Text(
                        logstate == LogState.logIn ? "Sign Up" : "Sign In",
                        style: const TextStyle(
                          color: Color(0xFF09B07D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ],
              ),
            SizedBox(height: size.height * 0.03),
            //forget password
            if (!widget.isloading)
              if (logstate == LogState.logIn)
                GestureDetector(
                  onTap: () {
                    widget.forgetPassword();
                  },
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
