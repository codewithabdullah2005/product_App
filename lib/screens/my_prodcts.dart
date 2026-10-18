import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/theme/app_colors.dart';
class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,

        title: const Row(
          children: [
            Icon(Icons.inventory_2),
            SizedBox(width: 10),
            Text(
              "My Products",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: user == null
          ? const Center(
        child: Text(
          "User not logged in",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where(
          'userId',
          isEqualTo: user.uid,
        )
            .snapshots(),

        builder: (context, snapshot) {
          // ================= LOADING =================
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ================= ERROR =================
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          // ================= EMPTY =================
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color:AppColors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "No Products Yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "You have not uploaded any products",
                    style: TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data!.docs;

          // ================= PRODUCT LIST =================
          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: products.length,

            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                elevation: 6,

                margin: const EdgeInsets.only(
                  bottom: 8,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Row(
                    children: [
                      // ================= PRODUCT ICON =================
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

                      // ================= PRODUCT INFO =================
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