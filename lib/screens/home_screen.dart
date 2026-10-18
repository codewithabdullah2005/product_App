import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'categories_screen.dart';
import 'package:product_app/theme/app_colors.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,

        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          // ================= CART =================
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: const Text(
              "Cart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

          // ================= PROFILE =================
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 10),
        ],
      ),

      // ================= BODY =================
      body: Center(
        child: Card(
          elevation: 12,

          // Card ka size bara kiya
          margin: const EdgeInsets.all(20),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 40,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                // ================= HEADING =================
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Manage your products",
                  style: TextStyle(
                    fontSize: 16,
                    color:AppColors.lime,
                  ),
                ),

                const SizedBox(height: 35),

                // ================= ADD PRODUCT =================
                SizedBox(
                  width: 250,
                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AddProductScreen(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.add),

                    label: const Text(
                      "Add Product",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= ALL PRODUCTS =================
                SizedBox(
                  width: 250,
                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ProductsScreen(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.shopping_bag),

                    label: const Text(
                      "All Products",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.category),
                  label: const Text(
                    "categories",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}