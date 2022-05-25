import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '/providers/user_provider.dart';
import '../other/models.dart';

class OrdersProvider with ChangeNotifier {
  bool dataLoaded = false;

  List<OrderItem> ordersList = [];
  Future<void> fechOrders() async {
    if (dataLoaded) {
      dataLoaded = false;
    }
    ordersList.clear();
    await UserProvider.fireStoreInstance
        .collection(UserProvider.fireAuthInstance.currentUser!.uid)
        .doc("shopfield")
        .collection("userorders")
        .orderBy("dateTime", descending: true)
        .get()
        .then((data) {
      ordersList = data.docs.map((order) {
        return OrderItem(
            id: order.id,
            amount: order.data()['amount'],
            products: List.from(order.data()['products'])
                .map((product) => CartItem.fromMap(product))
                .toList(),
            dataTime: order.data()['dateTime'].toDate());
      }).toList();
      dataLoaded = true;
      notifyListeners();
    });
  }

  Future<void> uploadOrder(Map<String, CartItem> items, double total) async {
    dataLoaded = false;
    Timestamp timestamp = Timestamp.now();
    UserProvider.fireStoreInstance
        .collection(UserProvider.fireAuthInstance.currentUser!.uid)
        .doc("shopfield")
        .collection("userorders")
        .add({
      'amount': total,
      'dateTime': timestamp,
      'products': items.values.map((singleProd) => singleProd.toMap()).toList(),
    }).then((order) {
      ordersList.add(OrderItem(
          id: order.id,
          amount: total,
          products: items.values.toList(),
          dataTime: timestamp.toDate()));
      dataLoaded = true;

      notifyListeners();
    });
  }

  void clearOrders() {
    ordersList = [];
  }
}
