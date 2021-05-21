//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screen
import '../screens/add_user_products_screen.dart';
import '../providers/products.dart';

class UserProducts extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserProducts({this.title, this.imgUrl, this.id});

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(
        "$title",
        style: Theme.of(context).textTheme.title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddProductsScreen.route, arguments: id);
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffold
                    .showSnackBar(SnackBar(content: Text("Delete failed!", textAlign: TextAlign.center,)));
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}
