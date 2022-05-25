import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '/other/constants.dart';
import '/providers/products_provider.dart';
import '/screens/edit_product/edit_product_screen.dart';

import 'components/user_product_item.dart';

class ManageProducts extends StatelessWidget {
  static const routeName = '/manage-product';

  const ManageProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
      ),
      body: Consumer<ProductProvider>(
          builder: (ctx, productsData, _) => Padding(
                padding: const EdgeInsets.all(4),
                child: ListView.builder(
                  itemCount: productsData.userProducts.length,
                  itemBuilder: (BuildContext _, int index) => Column(
                    children: [
                      UserProductItem(
                          productsData.userProducts[index].productId,
                          productsData.userProducts[index].productName,
                          productsData.userProducts[index].productImageUrl),
                      const Divider(),
                    ],
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => EditProductScreen())),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
