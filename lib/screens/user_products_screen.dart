//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//provider
import '../providers/products.dart';

//Screen
import '../screens/add_user_products_screen.dart';

//Widgets
import '../widgets/user_products.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static  const String route = "/User-Products";

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context).fetchAndSetProducts();
  }


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yours Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductsScreen.route);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
              child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  UserProducts(
                      title: productsData.items[i].title, imgUrl: productsData.items[i].imageUrl, id:  productsData.items[i].id),
                      Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
