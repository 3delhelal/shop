

// import 'package:flutter/material.dart';

// Widget stBuilder (){
//    StreamBuilder(
//                   stream: UserProvider.fireStoreInstance
//                       .collection(UserProvider.fireAuthInstance.currentUser.uid)
//                       .doc("chatfield")
//                       .collection("chats")
//                       .snapshots(),
//                   builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
//                     if (snapShot.connectionState == ConnectionState.waiting) {
//                       return IconButton(
//                         icon: SvgPicture.asset(
//                           "assets/icons/Chat bubble Icon.svg",
//                           color: Theme.of(context).scaffoldBackgroundColor ==
//                                   Colors.white
//                               ? Colors.white
//                               : kContentColorLightTheme,
//                         ),
//                         onPressed: () =>
//                             Navigator.pushNamed(context, MyChat.routeName),
//                       );
//                     }

//                     return IconBtnWithCounter(
//                         color: Theme.of(context).scaffoldBackgroundColor ==
//                                 Colors.white
//                             ? Colors.white
//                             : kContentColorLightTheme, // white Background for the buttonkSecondaryColor.withOpacity(0.1)
//                         numOfitem: snapShot.data.docs
//                             .where((element) =>
//                                 element.data()["messagelength"] !=
//                                 element.data()["seen"])
//                             .length,
//                         svgSrc: "assets/icons/Chat bubble Icon.svg",
//                         press: () =>
//                             Navigator.pushNamed(context, MyChat.routeName));
//                   },
//                 ),
// }