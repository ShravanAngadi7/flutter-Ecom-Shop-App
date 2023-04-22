import 'package:ecom_shop_app/providers/cart.dart' show Cart;
import 'package:ecom_shop_app/providers/orders.dart';
import '../widgets/cartitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cartscreen extends StatelessWidget {
  const Cartscreen({Key? key}) : super(key: key);
  static const routeName = '/Cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    //final cartItemList = cart.items.values.toList();
    // final item2 = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Total :',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                orderButton(cart: cart),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class orderButton extends StatefulWidget {
  const orderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<orderButton> createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearcart();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              '\'Order Now\'',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}



































    


// Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color: Colors.grey[800],
//         ),
//       ),
//       body: Consumer<Products>(
//         builder: (context, value, child) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Let's order fresh items for you
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Text(
//                   "My Cart",
//                   style: TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               // list view of cart
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: ListView.builder(
//                     itemCount: value.cartItems.length,
//                     padding: EdgeInsets.all(12),
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(8)),
//                           child: ListTile(
//                             leading: Image.asset(
//                               value.cartItems[index][2],
//                               height: 36,
//                             ),
//                             title: Text(
//                               value.cartItems[index][0],
//                               style: const TextStyle(fontSize: 18),
//                             ),
//                             subtitle: Text(
//                               '\$' + value.cartItems[index][1],
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.cancel),
//                               onPressed: () =>
//                                   Provider.of<Products>(context, listen: false)
//                                       .removeItemFromCart(index),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // total amount + pay now

//               Padding(
//                 padding: const EdgeInsets.all(36.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.green,
//                   ),
//                   padding: const EdgeInsets.all(24),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Total Price',
//                             style: TextStyle(color: Colors.green[200]),
//                           ),

//                           const SizedBox(height: 8),
//                           // total price
//                           Text(
//                             '\$${value.calculateTotal()}',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),

//                       // pay now
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.green.shade200),
//                           borderRadius: BorderRadius.circular(28),
//                         ),
//                         padding: const EdgeInsets.all(12),
//                         child: Row(
//                           children: const [
//                             Text(
//                               'Pay Now',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               size: 16,
//                               color: Colors.white,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }