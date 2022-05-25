// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class UploadUserPhoto extends StatefulWidget {
//   @override
//   _UploadUserPhotoState createState() => _UploadUserPhotoState();
// }

// class _UploadUserPhotoState extends State<UploadUserPhoto> {
//   var user = FirebaseAuth.instance.currentUser;

//   File _userImageFile;

//   final ImagePicker _picker = ImagePicker();
//   void _pickImage(ImageSource src) async {
//     final pickedImageFile = await _picker.getImage(
//       source: src,
//       imageQuality: 100,
//       maxHeight: 300,
//       maxWidth: 300,
//     );

//     if (pickedImageFile != null) {
//       setState(() {
//         _userImageFile = File(pickedImageFile.path);
//       });
//     } else {
//       return;
//     }
//     return;
//   }

//   void uploadPhoto(BuildContext ctx) async {
//     try {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('user_image')
//           .child(user.uid + '.jpg');
//       await ref.putFile(_userImageFile);

//       final url = await ref.getDownloadURL();
//       FirebaseFirestore.instance
//           .collection("userslist")
//           .doc(user.uid)
//           .update({"image_url": url});

//       user.updateProfile(photoURL: url);
//     } catch (erorr) {
//       showDialog(
//           context: ctx,
//           builder: (ctx) => AlertDialog(
//                 content: Text("Photo Upload Failed"),
//                 actions: [
//                   ElevatedButton(
//                     child: Text("Ok"),
//                     onPressed: () {
//                       Navigator.of(ctx).pop();
//                     },
//                   )
//                 ],
//               ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String gender = Provider.of<ScreenController>(context).gender;
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white.withOpacity(0.95),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: size.height * 0.1),
//             Text(
//               "Choose a picture",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: size.height * 0.02),
//             Text(
//               "To make your account more unique, please add a photo",
//             ),
//             SizedBox(height: size.height * 0.04),
//             _userImageFile != null
//                 ? CircleAvatar(
//                     radius: size.height * 0.1,
//                     backgroundImage: FileImage(
//                       _userImageFile,
//                     ),
//                   )
//                 : Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(150),
//                     ),
//                     margin: EdgeInsets.all(20),
//                     padding: EdgeInsets.all(20),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.asset(
//                         gender == "male"
//                             ? "assets/images/male.png"
//                             : "assets/images/female.png",
//                         scale: 1.7,
//                       ),
//                     ),
//                   ),
//             SizedBox(height: size.height * 0.02),
//             TextButton.icon(
//               label: Text("Select Image from Gellary"),
//               icon: Icon(
//                 Icons.image_outlined,
//                 size: 30,
//               ),
//               onPressed: () {
//                 try {
//                   _pickImage(ImageSource.gallery);
//                 } catch (e) {
//                   showDialog(
//                       context: context,
//                       builder: (ctx) => AlertDialog(
//                             content: Text("${e.toString()}"),
//                           ));
//                 }
//               },
//             ),
//             SizedBox(height: size.height * 0.02),
//             TextButton.icon(
//               label: Text("Select Image from Camera"),
//               icon: Icon(
//                 Icons.camera_alt_outlined,
//                 size: 30,
//               ),
//               onPressed: () {
//                 try {
//                   _pickImage(ImageSource.camera);
//                 } catch (e) {
//                   showDialog(
//                       context: context,
//                       builder: (ctx) => AlertDialog(
//                             content: Text("${e.toString()}"),
//                           ));
//                 }
//               },
//             ),
//             SizedBox(height: size.height * 0.1),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 10),
//                   width: size.width * 0.3,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(
//                             _userImageFile == null
//                                 ? Theme.of(context).disabledColor
//                                 : kPrimaryColor),
//                         padding: MaterialStateProperty.all(
//                             EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
//                       ),

//                       // disabledColor: Colors.grey.withOpacity(0.4),
//                       // disabledTextColor: Colors.black,

//                       onPressed: _userImageFile == null
//                           ? null
//                           : () {
//                               uploadPhoto(context);
//                               Provider.of<ScreenController>(context,
//                                       listen: false)
//                                   .changeSignupValue(false);
//                               Provider.of<ScreenController>(context,
//                                       listen: false)
//                                   .changeGenderValue(null);
//                             },
//                       child: Text(
//                         "Save",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Consumer<ScreenController>(
//                   builder: (ctx, val, child) => Container(
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     width: size.width * 0.3,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(50),
//                       child: TextButton(
//                         style: ButtonStyle(
//                             padding: MaterialStateProperty.all(
//                                 EdgeInsets.symmetric(
//                                     vertical: 20, horizontal: 20)),
//                             backgroundColor:
//                                 MaterialStateProperty.all(Colors.lightBlue)),
//                         onPressed: () {
//                           val.changeSignupValue(false);
//                           val.changeGenderValue(null);
//                         },
//                         child: Text(
//                           "Skip",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
