import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFave;

  const ProductsGrid(this.showFave);

  @override
  Widget build(BuildContext context) {
    final prodData = Provider.of<Products>(context);
    final products = showFave ? prodData.favoritesItems : prodData.items;
    return products.isEmpty
        ? Center(
            child: Text("No Product"),
          )
        : GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
