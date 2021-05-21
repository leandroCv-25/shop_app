import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/cart.dart';
import '../providers/products.dart';

//widgets
import '../widgets/grid_products_builder.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

//Screens
import './cart_screen.dart';

enum FilterOption {
  Favorites,
  All,
}

class ProdutsOverviewScreen extends StatefulWidget {
  @override
  _ProdutsOverviewScreenState createState() => _ProdutsOverviewScreenState();
}

class _ProdutsOverviewScreenState extends State<ProdutsOverviewScreen> {
  bool _initload = true;
  bool _error = false;
  bool _showFavoriteItems = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_initload) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _error = true;
        });
      });
    }
    _initload = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MyShop"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.Favorites) {
                    _showFavoriteItems = true;
                  } else {
                    _showFavoriteItems = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text(
                    "Only Favorites",
                  ),
                  value: FilterOption.Favorites,
                ),
                PopupMenuItem(
                  child: Text("Show All"),
                  value: FilterOption.All,
                )
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                color: Colors.amber,
                child: child,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.route);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _error
            ? Center(
                child: Column(
                  children: <Widget>[
                    Image.network(
                      "https://www.thestampmaker.com/stock_rubber_stamp_images/SSS2_SAD_FACE.jpg",
                      height: 200,
                    ),
                    Text(
                      "Something went wrong",
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(
                      "Try another time",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ],
                ),
              )
            : _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridProductsBuilder(_showFavoriteItems));
  }
}
