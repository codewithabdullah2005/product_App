import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'products_screen.dart';
import 'package:product_app/theme/app_colors.dart';
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.category),
            SizedBox(width: 10),
            Text(
              "Categories",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .orderBy(
          'createdAt',
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkGreen,
              ),
            );
          }

          // Error
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

          final categories =
              snapshot.data?.docs ?? [];

          // Empty
          if (categories.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No Categories Found",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          // Categories
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: categories.length,

            itemBuilder: (context, index) {
              final category = categories[index];

              final data =
              category.data()
              as Map<String, dynamic>;

              final categoryName =
                  data['name']?.toString() ??
                      'No Name';

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),

                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),

                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen
                          .withValues(alpha: 0.1),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.category,
                      color: AppColors.darkGreen,
                      size: 28,
                    ),
                  ),

                  title: Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColors.darkGreen,
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsScreen(
                          category: categoryName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}