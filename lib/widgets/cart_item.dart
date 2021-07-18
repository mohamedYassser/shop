import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantaty;

  final String title;

  const CartItem(
      this.id, this.productId, this.price, this.quantaty, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(

        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.redAccent.shade100,
          size: 45,
        ),
      ),
   direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context,
        builder: (ctx)=>AlertDialog(
          title: Text('Are Y sure'),
          content: Text('Do Y want remove Item in the cart'),
          actions: [
            FlatButton(onPressed: ()=>Navigator.of(context).pop(), child:Text('NO')),
            FlatButton(onPressed: ()=>Navigator.of(context).pop(true), child: Text('YES',))
          ],

        ));

      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total \$${(price * quantaty)} '),
            trailing: Text('$quantaty x'),
          ),
        ),
      ),
    );
  }
}
