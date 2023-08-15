import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/carts_provider.dart';
import '../page/cart_details_page.dart';

class CartsListView extends StatefulWidget {
  @override
  _CartsListViewState createState() => _CartsListViewState();
}

class _CartsListViewState extends State<CartsListView> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreCarts();
    }
  }

  Future<void> _loadMoreCarts() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<CartsProvider>(context, listen: false).fetchCarts(loadMore: true);
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartsProvider = Provider.of<CartsProvider>(context);
    final carts = cartsProvider.carts;

    return ListView.builder(
      controller: _scrollController,
      itemCount: carts.length + 1,
      itemBuilder: (context, index) {
        if (index < carts.length) {
          final cart = carts[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                'Cart ID: ${cart.id}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Total products: ${cart.products.length}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Total: \$${cart.total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'User ID: ${cart.userId}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartDetailsPage(cart: cart)),
                );
              },
            ),
          );
        } else if (_isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container(); // Placeholder for loading indicator
        }
      },
    );
  }
}
