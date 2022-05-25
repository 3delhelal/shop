import 'package:flutter/material.dart';
import '/providers/user_provider.dart';
import '../other/models.dart';

class ProductProvider with ChangeNotifier {
  bool dataLoaded = false;
  String filteringText = ""; // Filter the products during Search
  List<ProductItem> productsList = []; //Core Products

  List<ProductItem> get filteredProducts {
    return productsList
        .where((item) => item.productName
            .toLowerCase()
            .contains(filteringText.toLowerCase()))
        .toList();
  }

  List<ProductItem> get userProducts {
    return productsList
        .where((item) =>
            item.creatorId == UserProvider.fireAuthInstance.currentUser!.uid)
        .toList();
  }

  List<ProductItem> get userFavorites {
    return productsList
        .where((item) =>
            item.productName
                .toLowerCase()
                .contains(filteringText.toLowerCase()) &&
            item.isFavorite == true)
        .toList();
  }

  Future<void> fechData() async {
    if (dataLoaded) {
      dataLoaded = false;
    }
    productsList.clear();
    await UserProvider.fireStoreInstance
        .collection(UserProvider.fireAuthInstance.currentUser!.uid)
        .doc("shopfield")
        .collection("favProducts")
        .get()
        .then((favoriteQuery) {
      UserProvider.fireStoreInstance
          .collection("products")
          .get()
          .then((productsQuery) {
        productsList = productsQuery.docs
            .map((product) => ProductItem.fromMap(product.data()
              ..addAll({
                'productId': product.id,
                'isFavorite': favoriteQuery.docs
                    .map((doc) => doc.id)
                    .any((element) => element == product.id)
              })))
            .toList();
        dataLoaded = true;
        notifyListeners();
        // another way
        //  productsData.docs.forEach((product) {
        //   productsList.add(ProductItem.fromMap(product.data()
        //     ..addAll({
        //       'productId': product.id,
        //       'isFavorite': favorite.docs
        //           .map((doc) => doc.id)
        //           .any((element) => element == product.id)
        //     })));
        // });
      });
    });
  }

  ProductItem findById(String id) {
    return userProducts.firstWhere((prod) => prod.productId == id);
  }

  Future<void> addProduct(ProductItem product) async {
    UserProvider.fireStoreInstance
        .collection('products')
        .add(product.toMap())
        .then((refrence) {
      product.productId = refrence.id;
      productsList.add(product);
      notifyListeners();
    });
  }

  Future<void> updateProduct(String id, ProductItem newProduct) async {
    productsList[productsList.indexWhere((prod) => prod.productId == id)] =
        newProduct;
    UserProvider.fireStoreInstance
        .collection('products')
        .doc(id)
        .update(newProduct.toMap());
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final existingproductIndex =
        productsList.indexWhere((prod) => prod.productId == id);
    productsList.removeAt(existingproductIndex);
    UserProvider.fireStoreInstance.collection('products').doc(id).delete();
    notifyListeners();
  }

  void changeItemFav(String id) {
    int index = productsList.indexWhere((element) => element.productId == id);
    productsList[index].changeFav();
    notifyListeners();
    if (productsList[index].isFavorite) {
      UserProvider.fireStoreInstance
          .collection(UserProvider.fireAuthInstance.currentUser!.uid)
          .doc("shopfield")
          .collection("favProducts")
          .doc(id) //productsList[index].productId
          .set({});
    } else {
      UserProvider.fireStoreInstance
          .collection(UserProvider.fireAuthInstance.currentUser!.uid)
          .doc("shopfield")
          .collection("favProducts")
          .doc(id)
          .delete();
    }
  }

  void changeFilteringText(String text) {
    filteringText = text;
    notifyListeners();
  }

  void clearData() {
    productsList = [];
    filteringText = "";
  }
}
