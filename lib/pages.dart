import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers.dart';
import 'widgets.dart';
import 'models.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Product> products = [
    Product(name: 'Product 1', price: 10, imageUrl: 'asset/images/img1.jpg'),
    Product(name: 'Product 2', price: 20, imageUrl: 'asset/images/img2.jpg'),
    Product(name: 'Product 3', price: 30, imageUrl: 'asset/images/img3.jpg'),
    Product(name: 'Product 4', price: 40, imageUrl: 'asset/images/img4.jpg'),
    Product(name: 'Product 5', price: 50, imageUrl: 'asset/images/img5.jpg'),
    Product(name: 'Product 5', price: 50, imageUrl: 'asset/images/img6.jpg'),
    Product(name: 'Product 5', price: 50, imageUrl: 'asset/images/img7.jpg'),
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final favorites = Provider.of<Favorites>(context);

    final filteredProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kids Zone',
        cartItemCount: cart.items.length,
        favoriteItemCount: favorites.items.length,
        onSearchChanged: (value) {
          setState(() {
            query = value;
          });
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final int columns = (constraints.maxWidth / 200).floor();
          final double itemWidth = constraints.maxWidth / columns;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return Container(
                width: itemWidth,
                margin: EdgeInsets.all(8),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: Image.network(
                                  filteredProducts[index].imageUrl,
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Consumer<Favorites>(
                                  builder: (context, favorites, child) {
                                    final isFavorite = favorites
                                        .isFavorite(filteredProducts[index]);
                                    return IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                      onPressed: () {
                                        if (isFavorite) {
                                          favorites.removeFromFavorites(
                                              filteredProducts[index]);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '${filteredProducts[index].name} removed from favorites')),
                                          );
                                        } else {
                                          favorites.addToFavorites(
                                              filteredProducts[index]);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '${filteredProducts[index].name} added to favorites')),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          filteredProducts[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${filteredProducts[index].price.toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      AnimatedAddToCartButton(product: filteredProducts[index]),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final cartItem = cart.items[index];
          return ListTile(
            leading: Image.network(cartItem.product.imageUrl),
            title: Text(
              cartItem.product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              '\$${cartItem.product.price.toString()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeFromCart(cartItem);
                  },
                ),
                Text(
                  '${cartItem.quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .increaseQuantity(cartItem);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${cart.totalPrice.toString()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Your checkout logic here
              },
              child: Text(
                'Checkout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<Favorites>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.items.length,
        itemBuilder: (context, index) {
          final product = favorites.items[index];
          return ListTile(
            leading: Image.network(product.imageUrl),
            title: Text(
              product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              '\$${product.price.toString()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                Provider.of<Favorites>(context, listen: false)
                    .removeFromFavorites(product);
              },
            ),
          );
        },
      ),
    );
  }
}
