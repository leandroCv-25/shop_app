//flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/orders.dart' show Orders;

//widget
import '../widgets/order_item.dart' as ord;
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static String route = "/Order-Screen";

  @override
  Widget build(BuildContext context) {
    //final orders = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (datasnapshot.connectionState == ConnectionState.done) {
              return Consumer<Orders>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.orders.length,
                  itemBuilder: (context, i) {
                    return ord.OrderItem(orders.orders[i]);
                  },
                ),
              );
            }
            if (datasnapshot.error != null) {
              return Center(
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
              );
            }
          },
        ));
  }
}
