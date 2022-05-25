import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool dataLoaded = false;
  String changePassword = "";
  static FirebaseAuth fireAuthInstance = FirebaseAuth.instance;
  static FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;

  String? userName;
  String? userEmail;
  String? userImageUrl;

  fechData() async {
    if (dataLoaded) {
      dataLoaded = false;
    }
    await fireStoreInstance
        .collection("userslist")
        .doc(fireAuthInstance.currentUser!.uid)
        .get()
        .then((userQuery) {
      userName = userQuery.data()!['userName'];
      userEmail = userQuery.data()!['userEmail'];
      userImageUrl = userQuery.data()!['userImageUrl'];
      dataLoaded = true;
      if (userEmail != fireAuthInstance.currentUser!.email) {
        changeEmail();
      } else {
        notifyListeners();
      }
    });
  }

  void changeName(String text) {
    userName = text;
    notifyListeners();
  }

  void changeEmail() {
    FirebaseFirestore.instance
        .collection("userslist")
        .doc(fireAuthInstance.currentUser!.uid)
        .update({"userEmail": fireAuthInstance.currentUser!.email});
    userEmail = fireAuthInstance.currentUser!.email;
    notifyListeners();
  }

  void changeImageUrl(String text) {
    userImageUrl = text;
    notifyListeners();
  }

  void clearData() {
    changePassword = "";
    userName = "";
    userEmail = "";
    userImageUrl = "";
    dataLoaded = false;
  }
}
