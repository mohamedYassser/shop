import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authD = Provider.of<Auth>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
          child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(
                  product.imageUrl,
                ),
                fit: BoxFit.cover,
              )),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.white10,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon:
                  Icon(product.isFavo ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.togleFavo(authD.token, authD.userId);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("added to cart"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: "hide",
                      onPressed: () {
                        cart.removeSigleItem(product.id);
                      }),
                ));
              }),
        ),
      ),
    );
  }
}
