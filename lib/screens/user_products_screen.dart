import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/edit__product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user/product';
  //لب البيانات بفلتره id
  Future<void> _refreshProd(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UserProductScreen"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProd(context),
        builder: (ctx, AsyncSnapshot snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProd(context),
                    child: Consumer<Products>(
                        builder: (ctx, prodData, _) => Padding(
                              padding: EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: prodData.items.length,
                                itemBuilder: (_, int index) => Column(
                                  children: [
                                    UserProductItem(prodData.items[index].id,prodData.items[index].title,prodData.items[index].imageUrl),
                                  ],
                                ),
                              ),
                            )),
                  ),
      ),
    );
  }
}
