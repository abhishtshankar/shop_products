import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../page/favorites_page.dart';
import '../provider/products_providers.dart';
import '../page/product_details_page.dart';

class ProductsListView extends StatefulWidget {
  @override
  _ProductsListViewState createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts(loadMore: true);
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.products;

    return ListView.builder(
      controller: _scrollController,
      itemCount: products.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Color(0xffff5252),
            ),
            child: Text(
              'View Favorites',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        } else if (index < products.length + 1) {
          final product = products[index - 1];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                width: 80,
                height: 80,
                child: Image.network(product.thumbnail, fit: BoxFit.cover),
              ),
              title: Text(
                product.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffff5252),
                    ),
                  ),
                  Text(
                    'Discounted Price: \$${(product.price * (1 - product.discount / 100)).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
                );
              },
              trailing: IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite ? Theme.of(context).colorScheme.secondary : null,
                ),
                onPressed: () {
                  productsProvider.toggleFavoriteStatus(product.id);
                },
              ),
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
