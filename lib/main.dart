import 'package:ecom_shop_app/helpers/custom_rout.dart';
import 'package:ecom_shop_app/providers/Auth.dart';
import 'package:ecom_shop_app/providers/orders.dart';
import 'package:ecom_shop_app/screens/auth_screen.dart';
import 'package:ecom_shop_app/screens/cartscreen.dart';
import 'package:ecom_shop_app/screens/edit.product.screen.dart';
import 'package:ecom_shop_app/screens/orderscreen.dart';
import 'package:ecom_shop_app/screens/products_details_screen.dart';
import 'package:ecom_shop_app/screens/splash.dart';
import 'package:ecom_shop_app/screens/user_productScree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform
      // FirebaseOptions(
      //   apiKey: "AIzaSyCgtXDt2htmpu8fTzQr4H3jYT9Re8W-0Aw",
      //   appId: "1:466691410138:android:ffcf5d61bef8a96cd9bde3",
      //   messagingSenderId: "466691410138",
      //   projectId: "flutter-shop-app-c2494",
      // ),
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', "", []),
          update: (context, auth, previosProducts) => Products(
              auth.token,
              auth.userId,
              previosProducts == null ? [] : previosProducts.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', "", []),
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
            title: 'My Shop SIA',
            theme: ThemeData(
                primaryColor: Colors.deepPurpleAccent,
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: Colors.deepOrange,
                ),
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomePageTransitionBuilder(),
                  TargetPlatform.iOS: CustomePageTransitionBuilder(),
                })),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (
                      context,
                      authResultSnapShot,
                    ) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              Cartscreen.routeName: (context) => Cartscreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            }),
      ),
    );
  }
}










// //class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Shop s.i.a."),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text("let\'s build shop App"),
//       ),
//     );
//   }
// }
