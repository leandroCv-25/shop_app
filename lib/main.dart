//flutter package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//screens
import './screens/products_overview_screen.dart';
import './screens/products_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/add_user_products_screen.dart';
import './screens/auth_screen.dart';

//providers
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider(
          builder: (context) => Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: "Shop App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.grey,
          backgroundColor: Colors.black87,
          fontFamily: 'Lato',
          textTheme: TextTheme(
              headline: TextStyle(
            fontFamily: 'Anton',
            fontSize: 18,
            color: Colors.red,
          )),
        ),
        home: AuthScreen(),//ProdutsOverviewScreen(),
        routes: {
          ProductsDetailsScreen.route: (context) => ProductsDetailsScreen(),
          CartScreen.route: (context) => CartScreen(),
          OrderScreen.route: (context) => OrderScreen(),
          UserProductsScreen.route: (context) => UserProductsScreen(),
          AddProductsScreen.route: (context) => AddProductsScreen(),
          //AuthScreen.routeName: (context) => AuthScreen(),
        },
      ),
    );
  }
}
