import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';

class NewMessages extends StatefulWidget {
  final String friendId;
  final bool? isFromProduct;

  const NewMessages({
    Key? key,
    required this.friendId,
    this.isFromProduct,
  }) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";
  bool? _isFromProduct;

  @override
  void initState() {
    _isFromProduct = widget.isFromProduct;
    super.initState();
  }

  Future<void> addContact(String message) async {
    await FirebaseFirestore.instance
        .collection('userslist')
        .doc(widget.friendId)
        .get()
        .then((document) {
      FirebaseFirestore.instance
          .collection(UserProvider.fireAuthInstance.currentUser!.uid)
          .doc('chatfield')
          .collection('chats')
          .doc(widget.friendId)
          .set(
        {
          'userid': document.data()!['userId'],
          'username': document.data()!['userName'],
          'image_url': document.data()!['userImageUrl'],
          'messagelength': "1",
          'seen': "1",
          'lastmessage': message,
          'lastmessagedate': Timestamp.now(),
        },
      );
      FirebaseFirestore.instance
          .collection(widget.friendId)
          .doc('chatfield')
          .collection('chats')
          .doc(UserProvider.fireAuthInstance.currentUser!.uid)
          .set(
        {
          'userid': UserProvider.fireAuthInstance.currentUser!.uid,
          'username':
              Provider.of<UserProvider>(context, listen: false).userName,
          'image_url':
              Provider.of<UserProvider>(context, listen: false).userImageUrl,
          'messagelength': "1",
          'seen': "0",
          'lastmessage': message,
          'lastmessagedate': Timestamp.now(),
        },
      );
    });
  }

  _sendMessage(String msg) async {
    final user = FirebaseAuth.instance.currentUser;
    FocusScope.of(context).unfocus();
    if (_isFromProduct ?? false) {
      _isFromProduct = false;
      await FirebaseFirestore.instance
          .collection(widget.friendId)
          .doc('chatfield')
          .collection('chats')
          .get()
          .then((friendDocument) async {
        if (!friendDocument.docs.any((contact) => contact.id == user!.uid)) {
          await addContact(msg);
        }
      });
    }
    FirebaseFirestore.instance
        .collection(user!.uid)
        .doc('chatfield')
        .collection('chats')
        .doc(widget.friendId)
        .collection('chat')
        .add(
      {
        'text': msg,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'hide': false,
      },
    ).then((refrence) {
      FirebaseFirestore.instance
          .collection(widget.friendId)
          .doc('chatfield')
          .collection('chats')
          .doc(user.uid)
          .collection('chat')
          .doc(refrence.id)
          .set(
        {
          'text': msg,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'hide': false,
        },
      );
      if (_isFromProduct == false) {
        FirebaseFirestore.instance
            .collection(user.uid)
            .doc('chatfield')
            .collection('chats')
            .doc(widget.friendId)
            .update(
          {
            'lastmessage': msg,
            'lastmessagedate': Timestamp.now(),
          },
        );
        FirebaseFirestore.instance
            .collection(widget.friendId)
            .doc('chatfield')
            .collection('chats')
            .doc(user.uid)
            .update(
          {
            'lastmessage': msg,
            'lastmessagedate': Timestamp.now(),
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              ),
              style: const TextStyle(height: 1.2),
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
            color: Colors.lightGreen,
            disabledColor: Colors.grey,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage == ""
                ? null
                : () {
                    _sendMessage(_enteredMessage);
                    setState(() {
                      _enteredMessage = "";
                      _controller.clear();
                    });
                  },
          ),
        ],
      ),
    );
  }
}
