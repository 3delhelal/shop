import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';
import '../../../components/product_card.dart';

import '../../../other/enums.dart';
import '../../../other/size_config.dart';
import 'home_header.dart';

class Body extends StatelessWidget {
  final MenuState selectedMenu;
  const Body({required this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10.0)),
          HomeHeader(),
          SizedBox(height: getProportionateScreenWidth(10)),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 5),
            child: Row(
              children: [
                Text(
                  selectedMenu == MenuState.home ? "All Products" : "Favorite",
                  //TXTSTYLE
                  // style: Theme.of(context).textTheme.bodyText2,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                  ),
                  textAlign: TextAlign.right,
                )
              ],
            ),
          ),
          Consumer<ProductProvider>(builder: (ctx, productprov, _) {
            if (!productprov.dataLoaded) {
              return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.5),
                child: const CircularProgressIndicator(),
              );
            } else if (selectedMenu == MenuState.home &&
                productprov.filteredProducts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(productprov.filteringText == ""
                    ? "There are no products yet."
                    : "There are no products match your search"),
              );
            } else if (selectedMenu == MenuState.favourite &&
                productprov.userFavorites.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  productprov.filteringText == ""
                      ? "You have no favorite products yet."
                      : "There are no favorite products match your search",
                ),
              );
            } else {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: productprov.fechData,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: selectedMenu == MenuState.home
                          ? productprov.filteredProducts.length
                          : productprov.userFavorites.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (ctx, index) {
                        return ProductCard(index,
                            product: selectedMenu == MenuState.home
                                ? productprov.filteredProducts[index]
                                : productprov.userFavorites[index]);
                      },
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
