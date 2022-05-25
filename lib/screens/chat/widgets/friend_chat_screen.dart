// import 'package:shopping/other/constants.dart';

import '../../../screens/chat/new_message.dart';
import '../../../screens/chat/widgets/message.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatelessWidget {
  final String userName;
  final String imageUrl;
  final String userId;
  final int seen;
  final bool isFromProduct;

  const FriendScreen({
    required this.userName,
    required this.imageUrl,
    required this.userId,
    required this.seen,
    this.isFromProduct = false,
  });

  @override
  Widget build(BuildContext context) {
    final myid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            subtitle: const Text("Online"),
            title: Text(
              userName,
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        ),
        body: Stack(children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor == Colors.white
                ? const Color(0xFFE4DDD6)
                : Colors.black12,
            child: Opacity(
              opacity: 0.06,
              child: Image.asset(
                'assets/images/chat_background.png',
                repeat: ImageRepeat.repeatX,
              ),
            ),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
                child: Messages(
              myId: myid,
              friendId: userId,
              seen: seen,
            )),
            NewMessages(
              friendId: userId,
              isFromProduct: isFromProduct,
            ),
          ]),
        ]));
  }
}
