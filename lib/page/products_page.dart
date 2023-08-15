import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/carts_provider.dart';
import '../provider/products_providers.dart';
import '../listView/products_list_view.dart';
import '../listView/carts_list_view.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    await Provider.of<CartsProvider>(context, listen: false).fetchCarts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Products'),
            Tab(text: 'Cart'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProductsListView(),
          CartsListView(),
        ],
      ),
    );
  }
}

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ChangeNotifierProvider(create: (_) => CartsProvider()),
    ],
    child: ProductsApp(),
  ));
}

class ProductsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Products',
      home: ProductsPage(),
    );
  }
}
