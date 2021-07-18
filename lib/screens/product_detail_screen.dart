import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments  as String;
    final loadProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadProduct.title),
              background: Hero(
                tag: loadProduct.id,
                child: Image.network(
                  loadProduct.imageUrl,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadProduct.price}',textAlign: TextAlign.center,
                style: TextStyle(color: Colors.pink, fontSize: 20),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,

                child: Title( color:Colors.orange,child: Text(loadProduct.description,textAlign: TextAlign.center,softWrap: true,)),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
