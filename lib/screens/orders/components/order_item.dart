import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/other/constants.dart';
import '/other/models.dart';

class OrderWidget extends StatelessWidget {
  final OrderItem order;
  const OrderWidget(this.order);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
        subtitle: Text("${order.products.length} Product"),
        title: Text(
          DateFormat('dd/MM/yyyy  hh:mm a').format(order.dataTime),
        ),
        children: order.products
            .map((product) => Card(
                  child: ListTile(
                    title: Text(
                      "${product.title} ${product.quantity}x",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    leading: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: Colors.black26,
                            width: 2,
                          )),
                      child: Image.network(product.imageUrl),
                    ),
                    // leading: Text("${product.quantity}x"),
                    trailing: Text("\$${product.price * product.quantity}"),
                  ),
                ))
            .toList(),
        // Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           product.title,
        //           style:
        //               TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //         ),
        //         Text(
        //           '${product.quantity}x \$${product.price} ',
        //           style: TextStyle(fontSize: 18, color: Colors.grey),
        //         ),
        //       ],
        //     ))
        // .toList(),
      ),
    );
  }
}
