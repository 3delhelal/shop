import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/products_provider.dart';
import '../../../screens/edit_product/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => EditProductScreen(
                        currentProductId: id,
                      ))),
            ),
            IconButton(
              color: Theme.of(context).errorColor,
              icon: const Icon(Icons.delete),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text("Do you want to remove this product?"),
                          actions: [
                            TextButton(
                                child: const Text(
                                  "Ok",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .deleteProduct(id);
                                }),
                            TextButton(
                              child: const Text("Cancel",
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
