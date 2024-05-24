import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers.dart';
import 'models.dart';
import 'pages.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int cartItemCount;
  final int favoriteItemCount;
  final Function(String) onSearchChanged;

  CustomAppBar({
    required this.title,
    required this.cartItemCount,
    required this.favoriteItemCount,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$cartItemCount',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
            ),
            if (favoriteItemCount > 0)
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$favoriteItemCount',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
      ],
      toolbarHeight: 80.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(0),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: onSearchChanged,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(140.0);
}

class AnimatedAddToCartButton extends StatefulWidget {
  final Product product;

  AnimatedAddToCartButton({required this.product});

  @override
  _AnimatedAddToCartButtonState createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    Provider.of<Cart>(context, listen: false).addToCart(widget.product);
    _controller.forward().then((_) => _controller.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: ElevatedButton(
        onPressed: _addToCart,
        child: Text('Add to Cart'),
      ),
    );
  }
}
