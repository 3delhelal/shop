import 'package:cloud_firestore/cloud_firestore.dart';
import '/other/dateformating.dart';
import '/providers/user_provider.dart';
import '/screens/details/components/custom_app_bar.dart';

import '../../screens/chat/widgets/friend_chat_screen.dart';

import 'package:flutter/material.dart';

class MyChat extends StatelessWidget {
  static const routeName = '/chat-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(child: Text(''), preferredSize: Size.zero),
      // AppBar(
      //   title: Text("My Chat"),
      // ),
      body: StreamBuilder(
        stream: UserProvider.fireStoreInstance
            .collection(UserProvider.fireAuthInstance.currentUser!.uid)
            .doc('chatfield')
            .collection('chats')
            .orderBy("lastmessagedate", descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapShot.data!.docs
              .where((element) =>
                  element.id != UserProvider.fireAuthInstance.currentUser!.uid)
              .toList();
          if (docs.isEmpty) {
            return const Center(
              child: Text("You have no contacts yet."),
            );
          } else {
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (ctxx, index) {
                  return Column(
                    children: [
                      ListTile(
                        subtitle: Text(docs[index]['lastmessage']),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              docs[index]['lastmessage'] != ""
                                  ? dateFromating(
                                      docs[index]['lastmessagedate'])
                                  : "",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            int.parse(docs[index]['messagelength']) >
                                    int.parse(docs[index]['seen'])
                                ? Container(
                                    alignment: Alignment.center,
                                    height: 23,
                                    width: 23,
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        color: const Color(
                                            0xFF62D366), //0xFF09B07D
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Center(
                                      child: Text(
                                        "${int.parse(docs[index]['messagelength']) - int.parse(docs[index]['seen'])}",
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  )
                                : const Text(""),
                          ],
                        ),
                        title: Text(
                          docs[index]['username'],
                        ),
                        onTap: () => Navigator.of(ctx).push(
                          MaterialPageRoute(
                            builder: (ctx) => FriendScreen(
                              userName: docs[index]['username'],
                              imageUrl: docs[index]['image_url'],
                              userId: docs[index]['userid'],
                              seen: int.parse(docs[index]['seen']),
                              isFromProduct: false,
                            ),
                          ),
                        ),
                        leading: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      shape: const RoundedRectangleBorder(),
                                      content: SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: Image.network(
                                            docs[index]['image_url']),
                                      ),
                                    ));
                          },
                          child: CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                NetworkImage(docs[index]['image_url']),
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 10, bottom: 5, left: 4, right: 10),
                      ),
                      if (index != docs.length - 1) const Divider(),
                    ],
                  );
                });
          }
        },
      ),
    );
  }
}
