class UserData {
  final String userId;
  final String userName;
  final String userEmail;
  final String userImageUrl;

  UserData({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImageUrl,
  });
  factory UserData.fromMap(Map<String, dynamic> mapData) {
    return UserData(
      userId: mapData["userId"],
      userName: mapData["userName"],
      userEmail: mapData["userEmail"],
      userImageUrl: mapData["userImageUrl"],
    );
  }
}

class ProductItem {
  String productId;
  String productName;
  String productDescription;
  double productPrice;
  String productImageUrl;
  String creatorId;
  String creatorName;
  String creatorImageUrl;
  bool isFavorite;

  void changeFav() {
    isFavorite = !isFavorite;
  }

  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "productName": productName,
      "productDescription": productDescription,
      "productPrice": productPrice,
      "productImageUrl": productImageUrl,
      "creatorId": creatorId,
      "creatorName": creatorName,
      "creatorImageUrl": creatorImageUrl,
      "isFavorite": isFavorite,
    };
  }

  ProductItem(
      {required this.productId,
      required this.productName,
      required this.productDescription,
      required this.productPrice,
      required this.productImageUrl,
      required this.creatorId,
      required this.creatorName,
      required this.creatorImageUrl,
      required this.isFavorite});

  factory ProductItem.fromMap(Map<String, dynamic> mapData) {
    return ProductItem(
        productId: mapData["productId"],
        productName: mapData["productName"],
        productDescription: mapData["productDescription"],
        productPrice: mapData["productPrice"]
            .toDouble(), //double.parse(mapData["productPrice"])
        productImageUrl: mapData["productImageUrl"],
        creatorId: mapData["creatorId"],
        creatorName: mapData["creatorName"],
        creatorImageUrl: mapData["creatorImageUrl"],
        isFavorite: mapData["isFavorite"]);
  }
}

class CartItem {
  final String itemId;
  final String title;
  final String imageUrl;
  int quantity;
  final double price;

  CartItem({
    this.itemId = '',
    required this.title,
    this.imageUrl = '',
    required this.quantity,
    required this.price,
  });
  factory CartItem.fromMap(Map<String, dynamic> mapData) {
    return CartItem(
        itemId: mapData['itemid'],
        title: mapData['itemtitle'],
        quantity: mapData['itemquantity'],
        imageUrl: mapData['itemimageurl'],
        price: mapData['itemprice']);
  }
  Map<String, dynamic> toMap() {
    return {
      'itemid': itemId,
      'itemtitle': title,
      'itemquantity': quantity,
      'itemimageurl': imageUrl,
      'itemprice': price,
    };
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dataTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dataTime,
  });
}
