import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/theme/app_colors.dart';
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.shopping_bag),
            SizedBox(width: 10),
            Text(
              "Product Detail",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get(),

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkGreen,
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 70,
                    color: Colors.red,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Something went wrong",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          // Product not found
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppColors.darkGreen,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Product Not Found",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          final product =
          snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Product Icon
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            size: 55,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Product Name
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color:AppColors.darkGreen,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${product['price']}",
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color:AppColors.darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Description Heading
                      const Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: AppColors.darkGreen,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Description
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product['description'],
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Product ID Heading
                      const Row(
                        children: [
                          Icon(
                            Icons.fingerprint,
                            color: AppColors.darkGreen,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Product ID",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Product ID
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          productId,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}