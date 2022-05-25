// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/other/constants.dart';
import '/providers/user_provider.dart';
import '/screens/update_profile/components/acount_pic.dart';
import '/screens/update_profile/components/menu_list_tile.dart';

class UpdateProfile extends StatefulWidget {
  static const String routeName = "/editprofile";

  const UpdateProfile({Key? key}) : super(key: key);

  @override
  UpdateProfileState createState() => UpdateProfileState();
}

class UpdateProfileState extends State<UpdateProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _userName = "";
  String _email = "";
  final _emailFormKey = GlobalKey<FormFieldState>();
  final _userNameFormKey = GlobalKey<FormFieldState>();
  final _passwordFormKey = GlobalKey<FormState>();

  String _password = "";
  bool _uploadingImage = false;
  final ImagePicker _picker = ImagePicker();
  String? userName;

  String? imageUrl;
  @override
  void initState() {
    _userName =
        Provider.of<UserProvider>(context, listen: false).userName ?? '';
    imageUrl = Provider.of<UserProvider>(context, listen: false).userImageUrl;
    if (Provider.of<UserProvider>(context, listen: false).userEmail !=
        UserProvider.fireAuthInstance.currentUser!.email) {
      print(UserProvider.fireAuthInstance.currentUser!.email);
      print(Provider.of<UserProvider>(context, listen: false).userEmail);
      Provider.of<UserProvider>(context, listen: false).changeEmail();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              if (_uploadingImage)
                const SpinKitFoldingCube(
                  size: 60,
                  duration: Duration(
                    seconds: 3,
                  ),
                  color: Colors.lightGreen,
                ),
              if (!_uploadingImage)
                AccountPic(
                  context: context,
                  imageUrl: imageUrl ?? '',
                  press: changeProfilePic,
                ),
              SizedBox(
                height: size.height * 0.05,
              ),
              // User Name
              MenuListTile(
                title: "User name",
                subTitle: _userName,
                icon: Icons.person_outline,
                press: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) => SingleChildScrollView(
                            child: Padding(
                              // padding: EdgeInsets.zero,
                              padding: MediaQuery.of(context).viewInsets,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 20),
                                        child: const Text("Your name"),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.12),
                                    constraints: const BoxConstraints(
                                        minHeight: 100, maxHeight: 200),
                                    width: double.infinity,
                                    child: TextFormField(
                                      key: _userNameFormKey,
                                      onChanged: (text) {
                                        _userName = text;
                                      },
                                      autofocus: true,
                                      decoration: const InputDecoration(),
                                      initialValue: _userName,
                                      validator: (text) {
                                        if (text!.isEmpty || text.length < 4) {
                                          return "Please enter at least 4 characters";
                                        }
                                        if (text.isEmpty || text.length > 16) {
                                          return "username maximum characters is 16";
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: const Text("Save"),
                                        onPressed: () async {
                                          if (_userNameFormKey.currentState!
                                              .validate()) {
                                            _userNameFormKey.currentState!
                                                .save();
                                            UserProvider
                                                .fireAuthInstance.currentUser!
                                                .updateProfile(
                                                    displayName: _userName);

                                            setState(() {});
                                            Navigator.of(ctx).pop();

                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection("userslist")
                                                  .doc(UserProvider
                                                      .fireAuthInstance
                                                      .currentUser!
                                                      .uid)
                                                  .update({
                                                'userName': _userName,
                                              });
                                              var x = await FirebaseFirestore
                                                  .instance
                                                  .collection(UserProvider
                                                      .fireAuthInstance
                                                      .currentUser!
                                                      .uid)
                                                  .doc('users')
                                                  .collection('friends')
                                                  .get();
                                              var friends = x.docs;
                                              for (var friend in friends) {
                                                FirebaseFirestore.instance
                                                    .collection(friend.id)
                                                    .doc("users")
                                                    .collection("friends")
                                                    .doc(UserProvider
                                                        .fireAuthInstance
                                                        .currentUser!
                                                        .uid)
                                                    .update({
                                                  "username": _userName
                                                });
                                                // ignore: use_build_context_synchronously
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .changeName(_userName);
                                              }
                                            } catch (erorr) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        content: const Text(
                                                            "An error occurred while updating the name."),
                                                        actions: [
                                                          ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .blue)),
                                                            child: const Text(
                                                                "Ok"),
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ));
                                            }
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                },
              ),
              MenuListTile(
                  title: "Email",
                  subTitle:
                      UserProvider.fireAuthInstance.currentUser!.email ?? '',
                  icon: Icons.email_outlined,
                  press: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) => SingleChildScrollView(
                              child: Padding(
                                // padding: EdgeInsets.zero,
                                padding: MediaQuery.of(context).viewInsets,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 20),
                                          child: const Text("Your new Email"),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.12),
                                      constraints: const BoxConstraints(
                                          minHeight: 100, maxHeight: 200),
                                      width: double.infinity,
                                      child: TextFormField(
                                        key: _emailFormKey,
                                        onSaved: (text) {
                                          _email = text ?? '';
                                        },
                                        autofocus: true,
                                        decoration: const InputDecoration(),
                                        initialValue: UserProvider
                                                .fireAuthInstance
                                                .currentUser!
                                                .email ??
                                            '',
                                        validator: (val) {
                                          if (val!.isEmpty ||
                                              !val.contains("@")) {
                                            return "Please enter a valid email adress";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          child: const Text(
                                              "Send verification link"),
                                          onPressed: () async {
                                            if (_emailFormKey.currentState!
                                                .validate()) {
                                              _emailFormKey.currentState!
                                                  .save();

                                              Navigator.of(ctx).pop();
                                              try {
                                                await UserProvider
                                                    .fireAuthInstance
                                                    .currentUser!
                                                    .updateEmail(_email);

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (ctx) => AlertDialog(
                                                              title: const Text(
                                                                  "email verification successfully sent"),
                                                              content: Text(
                                                                  "We have sent email verification link to your email : ${UserProvider.fireAuthInstance.currentUser!.email}"),
                                                              actions: [
                                                                ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              Colors.blue)),
                                                                  child:
                                                                      const Text(
                                                                          "Ok"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            ctx)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ));

                                                _email = "";
                                              } on FirebaseAuthException catch (erorr) {
                                                String message =
                                                    "UnKnown Erorr";
                                                if (erorr.code ==
                                                    "invalid-email") {
                                                  message =
                                                      "This email adress is not vaild.";
                                                } else if (erorr.code ==
                                                    "email-already-in-use") {
                                                  message =
                                                      "This email address is already in use by another account.";
                                                } else {
                                                  message = erorr.code;
                                                }

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (ctx) => AlertDialog(
                                                              content:
                                                                  Text(message),
                                                              actions: [
                                                                ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              Colors.blue)),
                                                                  child:
                                                                      const Text(
                                                                          "Ok"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            ctx)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ));
                                              } catch (erorr) {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        AlertDialog(
                                                          content: Text(
                                                              erorr.toString()),
                                                          actions: [
                                                            ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .blue)),
                                                              child: const Text(
                                                                  "Ok"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ));
                                              }
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  }),
              MenuListTile(
                  title: "Password",
                  subTitle: "*********",
                  icon: Icons.lock_open_rounded,
                  press: () {
                    if (Provider.of<UserProvider>(context, listen: false)
                            .changePassword !=
                        UserProvider.fireAuthInstance.currentUser!.uid) {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Warning"),
                                content: const Text(
                                    "Changing the password requires a Re-login"),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      "Re-login",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .changePassword =
                                          UserProvider.fireAuthInstance
                                              .currentUser!.uid;
                                      Navigator.of(ctx).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(ctx).pop();
                                      FirebaseAuth.instance.signOut();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                ],
                              ));
                    } else {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) => SingleChildScrollView(
                                child: Padding(
                                  // padding: EdgeInsets.zero,
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 20),
                                            child: const Text(
                                                "Enter your password"),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.12),
                                        constraints: const BoxConstraints(
                                            minHeight: 50, maxHeight: 100),
                                        width: double.infinity,
                                        child: Form(
                                          key: _passwordFormKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextFormField(
                                                autofocus: true,
                                                obscureText: true,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "New password",
                                                  border: InputBorder.none,
                                                ),
                                                cursorColor: kPrimaryColor,
                                                onChanged: (fieldvalue) =>
                                                    _password = fieldvalue,
                                                validator: (val) {
                                                  if (val!.isEmpty ||
                                                      val.length < 6) {
                                                    return "Password must be at least 6 characters";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                obscureText: true,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Confirm Password",
                                                  border: InputBorder.none,
                                                ),
                                                validator: (val) {
                                                  if (_password != val ||
                                                      _password == "") {
                                                    return "Confirm password do not match";
                                                  }
                                                  return null;
                                                },
                                                cursorColor: kPrimaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: const Text("Confirm"),
                                            onPressed: () async {
                                              try {
                                                if (_passwordFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  _passwordFormKey.currentState!
                                                      .save();
                                                  Navigator.of(ctx).pop();
                                                  UserProvider.fireAuthInstance
                                                      .currentUser!
                                                      .updatePassword(
                                                          _password);
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("userslist")
                                                      .doc(UserProvider
                                                          .fireAuthInstance
                                                          .currentUser!
                                                          .uid)
                                                      .update({
                                                    'password': _password,
                                                  });

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Password changed successfully "),
                                                    duration:
                                                        Duration(seconds: 3),
                                                  ));
                                                  _password = "";
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .changePassword = "";
                                                }
                                              } catch (erorr) {
                                                _password = "";
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              "Something went wrong"),
                                                          content: Text(
                                                              erorr.toString()),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
                                                                  "Ok"),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          ctx)
                                                                      .pop(),
                                                            ),
                                                          ],
                                                        ));
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void changeProfilePic(BuildContext context, ImageSource src) async {
    Navigator.of(context).pop();
    final pickedImageFile = await _picker.getImage(
      source: src,
      // imageQuality: 100,
      // maxHeight: 300,
      // maxWidth: 300,
    );
    if (pickedImageFile != null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Container(
                  constraints:
                      const BoxConstraints(minHeight: 100, maxHeight: 250),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        minRadius: 30,
                        maxRadius: 60,
                        foregroundColor: Colors.green,
                        backgroundImage: FileImage(File(pickedImageFile.path)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Change profile picture?")
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "Change it",
                    ),
                    onPressed: () async {
                      setState(() {
                        _uploadingImage = true;
                      });
                      Navigator.of(context).pop();

                      try {
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('user_image')
                            .child(
                                '${UserProvider.fireAuthInstance.currentUser!.uid}.jpg');
                        await ref.putFile(File(pickedImageFile.path));

                        final url = await ref.getDownloadURL();
                        FirebaseFirestore.instance
                            .collection("userslist")
                            .doc(UserProvider.fireAuthInstance.currentUser!.uid)
                            .update({"userImageUrl": url});

                        UserProvider.fireAuthInstance.currentUser!
                            .updateProfile(photoURL: url);

                        await FirebaseFirestore.instance
                            .collection(
                                UserProvider.fireAuthInstance.currentUser!.uid)
                            .doc('chatfield')
                            .collection('chats')
                            .get()
                            .then((queryData) {
                          for (var friend in queryData.docs) {
                            FirebaseFirestore.instance
                                .collection(friend.id)
                                .doc("chatfield")
                                .collection("chats")
                                .doc(UserProvider
                                    .fireAuthInstance.currentUser!.uid)
                                .update({"image_url": url});
                          }
                        });

                        setState(() {
                          imageUrl = url;
                          _uploadingImage = false;
                        });
                        Provider.of<UserProvider>(context, listen: false)
                            .changeImageUrl(url);
                      } catch (erorr) {
                        setState(() {
                          _uploadingImage = false;
                        });
                        showDialog(
                            context: ctx,
                            builder: (ctx) => AlertDialog(
                                  content: const Text("Photo Upload Failed"),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                ));
                      }
                    },
                  ),
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ));
    }
  }
}
