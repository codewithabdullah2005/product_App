import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_detail_screen.dart';
import 'package:product_app/theme/app_colors.dart';
class ProductsScreen extends StatefulWidget {
  final String? category;

  const ProductsScreen({
    super.key,
    this.category,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Set<String> favoriteProducts = {};

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // Load user's favourite products
  Future<void> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    if (!mounted) return;

    setState(() {
      favoriteProducts =
          snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  // Add product to favourite
  Future<void> addToFavorite(
      DocumentSnapshot product,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final productId = product.id;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final userData = userDoc.data();

    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId);

    await favoriteRef.set({
      'productId': productId,
      'productName': product['name'],
      'productPrice': product['price'],
      'productDescription': product['description'],
      'userName': userData?['name'] ?? '',
      'userEmail': userData?['email'] ?? '',
    });

    if (!mounted) return;

    setState(() {
      favoriteProducts.add(productId);
    });
  }

  // Add product to cart
  Future<void> addToCart(
      DocumentSnapshot product,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final productId = product.id;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId);

    final cartDoc = await cartRef.get();

    if (cartDoc.exists) {
      final currentQuantity =
      cartDoc['quantity'] as int;

      await cartRef.update({
        'quantity': currentQuantity + 1,
      });
    } else {
      await cartRef.set({
        'productId': productId,
        'productName': product['name'],
        'productPrice': product['price'],
        'quantity': 1,
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product added to cart"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.shopping_bag),
            const SizedBox(width: 10),
            Text(
              widget.category == null
                  ? "Products"
                  : widget.category!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: widget.category == null
            ? FirebaseFirestore.instance
            .collection('products')
            .snapshots()
            : FirebaseFirestore.instance
            .collection('products')
            .where(
          'category',
          isEqualTo: widget.category,
        )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkGreen,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.category == null
                        ? "No Products Found"
                        : "No Products in ${widget.category}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: products.length,

            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                elevation: 6,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: InkWell(
                  borderRadius: BorderRadius.circular(18),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(
                              productId: product.id,
                            ),
                      ),
                    );
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      children: [

                        // Product Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.darkGreen
                                .withValues(alpha: 0.1),
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: AppColors.darkGreen,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 15),

                        // Product Information
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                product['name'],
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 7),

                              Text(
                                "Price: ${product['price']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.darkGreen,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Favourite Button
                        IconButton(
                          onPressed: () {
                            addToFavorite(product);
                          },
                          icon: Icon(
                            favoriteProducts
                                .contains(product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteProducts
                                .contains(product.id)
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),

                        // Cart Button
                        IconButton(
                          onPressed: () {
                            addToCart(product);
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
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