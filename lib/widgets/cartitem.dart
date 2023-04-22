import 'package:provider/provider.dart';

import '../providers/cart.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete_sweep_outlined,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Are you sure..?'),
                content: const Text(
                    'Do you want to remove this item from the cart!'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('NO')),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes')),
                ],
              )),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 13.0,
          vertical: 4.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price')),
            ),
            trailing: Text('Qty:$quantity'),
          ),
        ),
      ),
    );
  }
}
