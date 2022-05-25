import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/components/forgot_password.dart';
import '../auth/components/login_signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  bool _forgotpassowrd = false;
  void _forgotPasswordMethod() {
    setState(() {
      _forgotpassowrd = !_forgotpassowrd;
    });
  }

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection("userslist")
            .doc(authResult.user!.uid)
            .set(
          {
            'userId': authResult.user!.uid,
            'userName': username,
            'userEmail': email,
            'password': password,
            'userImageUrl':
                "https://www12.0zz0.com/2021/05/21/20/865510145.png",
            'createdAt': Timestamp.now(),
            'lastSeen': FieldValue.serverTimestamp(),
          },
        );
        authResult.user!.updateProfile(
            displayName: username,
            photoURL: "https://www12.0zz0.com/2021/05/21/20/865510145.png");
      }
    } on FirebaseAuthException catch (e) {
      String message = "internet connection error.";
      if (e.code == 'weak-password') {
        message = 'password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'this account already exists.';
      } else if (e.code == 'user-not-found') {
        message = 'email is not found.';
      } else if (e.code == 'wrong-password') {
        message = 'wrong password.';
      } else if (e.code == 'invalid-email') {
        message = 'invalid email.';
      } else if (e.code == 'network-request-failed') {
        message = 'network connection error.';
      } else {
        message = e.code;
      }
      showDialog(
          context: ctx,
          builder: (ctxx) => AlertDialog(
                title: const Text("Server responde :"),
                content: Text(
                  message,
                  style: const TextStyle(fontSize: 18),
                ),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error HAPPENS Catch");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _forgotpassowrd
            ? ForgotPassword(_forgotPasswordMethod)
            : LogScreen(_forgotPasswordMethod, _submitAuthForm, _isLoading),
      ),
    );
  }
}
