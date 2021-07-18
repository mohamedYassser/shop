import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoding = false;
  var _shoOnlyFa = false;

  @override
  void initState() {
    super.initState();
    _isLoding = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetData()
        .then(
          (_) => setState(
            () => _isLoding = false,
          ),
        )
        .catchError((_) => setState(
              () => _isLoding = false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedVal) {
              setState(() {
                if (selectedVal == FilterOption.Favorites) {
                  _shoOnlyFa = true;
                } else {
                  _shoOnlyFa = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('ShowAll'),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routName),
            ),
            builder: (_, cart, child) => Badge(
              child: child,
              valu: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: _isLoding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_shoOnlyFa),
      drawer: AppDrawer(),
    );
  }
}
