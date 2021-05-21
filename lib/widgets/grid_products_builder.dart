//package flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//widgets
import './product_item.dart';

//Providers
//import '../providers/product.dart';
import '../providers/products.dart';

class GridProductsBuilder extends StatelessWidget {
  final bool _showFavoritesItems;

  GridProductsBuilder(this._showFavoritesItems);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        _showFavoritesItems ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //builder: (context)=>products[index],
        value: products[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
