import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/theme/app_colors.dart';
class FavouriteProductScreen extends StatelessWidget {
  const FavouriteProductScreen({super.key});

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
            Icon(Icons.favorite),
            SizedBox(width: 10),
            Text(
              "Favourite",
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
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
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
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "No Favourite Products",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Your favourite products will appear here",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final favorites =
              snapshot.data!.docs;

          // ================= FAVOURITE LIST =================
          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: favorites.length,

            itemBuilder: (context, index) {
              final product =
              favorites[index];

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
                  padding:
                  const EdgeInsets.all(16),

                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      // ================= PRODUCT ICON =================
                      Container(
                        width: 60,
                        height: 60,

                        decoration: BoxDecoration(
                          color:AppColors.darkGreen
                              .withValues(alpha: 0.1),

                          borderRadius:
                          BorderRadius.circular(15),
                        ),

                        child: const Icon(
                          Icons.shopping_bag,
                          color: AppColors.darkGreen,
                          size: 30,
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
                              product[
                              'productName'],
                              style:
                              const TextStyle(
                                fontSize: 19,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              "Price: ${product['productPrice']}",
                              style:
                              const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                                color:
                                AppColors.darkGreen,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              product[
                              'productDescription'],
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,

                              style:
                              const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ================= FAVOURITE ICON =================
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 27,
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