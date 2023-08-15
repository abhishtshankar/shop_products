import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/page/product_details_page.dart';
import 'package:untitled/provider/products_providers.dart';


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final favoriteProducts = productsProvider.products.where((product) => product.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
      ),
      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.network(product.thumbnail),
              title: Text(product.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.description),
                  SizedBox(height: 4),
                  Text('\$${product.price.toStringAsFixed(2)}'),
                  Text(
                    'Discounted Price: \$${(product.price * (1 - product.discount / 100)).toStringAsFixed(2)}',
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
