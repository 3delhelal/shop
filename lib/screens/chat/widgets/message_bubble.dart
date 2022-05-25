import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:clipboard/clipboard.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp mTime;
  final String docId;
  final String myId;
  final String friendId;
  final bool isLastMsg;

  const MessageBubble(this.message, this.isMe, this.mTime, this.docId,
      this.myId, this.friendId, this.isLastMsg,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(left: 10, right: 10, top: 0))),
        onPressed: () {
          showToast(context);
        },
        onLongPress:
            message == "message deleted" || message == "message deleted"
                ? null
                : () {
                    modalButtonSh(context);
                  },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300, minWidth: 30),
          padding: const EdgeInsets.only(left: 7, right: 3, top: 8, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft:
                  isMe ? const Radius.circular(6) : const Radius.circular(7),
              topRight:
                  !isMe ? const Radius.circular(6) : const Radius.circular(7),
              bottomRight: const Radius.circular(7),
              bottomLeft: const Radius.circular(7),
            ),
            color: isMe ? const Color(0xFFE2F7CB) : Colors.grey[200],
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 3, bottom: 2),
                child: Text(message,
                    style: TextStyle(
                        color: message == "message deleted" ||
                                message == "message deleted"
                            ? Colors.red
                            : Colors.black)),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      DateFormat('hh:mm a').format(mTime.toDate()),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black45),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showToast(BuildContext ctx) {
    Toast.show(
        "${DateFormat("EEEE").format(mTime.toDate())}  ${DateFormat("jm").format(mTime.toDate())}  -  ${DateFormat("dd-MM-yyyy").format(mTime.toDate())}",
        duration: 3,
        gravity: Toast.bottom);
  }

  Future alertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                "Are you sure?",
              ),
              content: const Text("Do you want to delete the message?"),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMe)
                      TextButton(
                        onPressed: !isMe
                            ? null
                            : message == "message deleted"
                                ? null
                                : () async {
                                    Navigator.of(ctx).pop();
                                    await FirebaseFirestore.instance
                                        .collection(myId)
                                        .doc('chatfield')
                                        .collection('chats')
                                        .doc(friendId)
                                        .collection('chat')
                                        .doc(docId)
                                        .update({'text': "message deleted"});
                                    await FirebaseFirestore.instance
                                        .collection(friendId)
                                        .doc('chatfield')
                                        .collection('chats')
                                        .doc(myId)
                                        .collection('chat')
                                        .doc(docId)
                                        .update({'text': "message deleted"});
                                    FirebaseFirestore.instance
                                        .collection(myId)
                                        .doc('chatfield')
                                        .collection('chats')
                                        .doc(friendId)
                                        .collection('chat')
                                        .orderBy('createdAt', descending: true)
                                        .get()
                                        .then((data) {
                                      var lastMsg = data.docs.firstWhere(
                                        (element) =>
                                            element.data()['hide'] == false,
                                        // orElse: () => null,
                                      );
                                      if (lastMsg.id == docId) {
                                        FirebaseFirestore.instance
                                            .collection(myId)
                                            .doc('chatfield')
                                            .collection('chats')
                                            .doc(friendId)
                                            .update({
                                          'lastmessage': "message deleted",
                                        });
                                      }
                                    });
                                    FirebaseFirestore.instance
                                        .collection(friendId)
                                        .doc('chatfield')
                                        .collection('chats')
                                        .doc(myId)
                                        .collection('chat')
                                        .orderBy('createdAt', descending: true)
                                        .get()
                                        .then((data) {
                                      var lastMsg = data.docs.firstWhere(
                                        (element) =>
                                            element.data()['hide'] == false,
                                        // orElse: () => null,
                                      );
                                      if (lastMsg.id == docId) {
                                        FirebaseFirestore.instance
                                            .collection(friendId)
                                            .doc('chatfield')
                                            .collection('chats')
                                            .doc(myId)
                                            .update({
                                          'lastmessage': "message deleted",
                                        });
                                      }
                                    });
                                  },
                        child: const Text(
                          "Delete from all",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            child: const Text(
                              "Delete from me",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              Navigator.of(ctx).pop();
                              await FirebaseFirestore.instance
                                  .collection(myId)
                                  .doc('chatfield')
                                  .collection('chats')
                                  .doc(friendId)
                                  .collection('chat')
                                  .doc(docId)
                                  .update({'hide': true});
                              if (isLastMsg) {
                                FirebaseFirestore.instance
                                    .collection(myId)
                                    .doc('chatfield')
                                    .collection('chats')
                                    .doc(friendId)
                                    .collection('chat')
                                    .orderBy('createdAt', descending: true)
                                    .get()
                                    .then((data) {
                                  var lastMsg = data.docs.firstWhere(
                                    (element) =>
                                        element.data()['hide'] == false,
                                    // orElse: () => null,
                                  );

                                  if (lastMsg == null) {
                                    FirebaseFirestore.instance
                                        .collection(myId)
                                        .doc('chatfield')
                                        .collection('chats')
                                        .doc(friendId)
                                        .update({
                                      'lastmessage': "",
                                      'lastmessagedate': Timestamp.now(),
                                    });
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection(myId)
                                        .doc('chatfield')
                                        .collection('chats')
                                        .doc(friendId)
                                        .update({
                                      'lastmessage': lastMsg.data()['text'],
                                      'lastmessagedate':
                                          lastMsg.data()['createdAt'],
                                    });
                                  }
                                });
                              }
                            }),
                        TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.only(right: 10))),
                          child: Text(
                            "Cancle",
                            style: TextStyle(color: Colors.blue[300]),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ));
  }

  modalButtonSh(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (ctx) => Container(
        constraints: const BoxConstraints(minHeight: 30, maxHeight: 80),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                FlutterClipboard.copy(message);
                Navigator.pop(ctx);
                Toast.show(
                  "Message Copied",
                  duration: 2,
                  gravity: 0,
                  backgroundRadius: 30,
                );
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.content_copy,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Copy",
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                alertDialog(context);
              },
              child: Column(
                children: const [
                  Icon(Icons.delete_forever_rounded),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Delete Message",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
