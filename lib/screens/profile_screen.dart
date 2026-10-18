import 'package:flutter/material.dart';
import 'package:product_app/screens/my_prodcts.dart';
import 'favorite_product_screen.dart';
import 'my_orders.dart';
import 'package:product_app/theme/app_colors.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,

        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      // ================= BODY =================
      body: Center(
        child: Card(
          elevation: 8,

          margin: const EdgeInsets.all(25),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(50),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                // ================= PROFILE ICON =================
                Container(
                  width: 90,
                  height: 90,

                  decoration: const BoxDecoration(
                    color: AppColors.darkGreen,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 55,
                  ),
                ),

                const SizedBox(height: 20),

                // ================= TITLE =================
                const Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // ================= MY PRODUCTS =================
                SizedBox(
                  width: 250,
                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const MyProductsScreen(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.inventory_2,
                    ),

                    label: const Text(
                      "My Products",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,

                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ================= FAVOURITE =================
                SizedBox(
                  width: 250,
                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const FavouriteProductScreen(),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.favorite,
                    ),

                    label: const Text(
                      "Favourite",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,

                      elevation: 4,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyOrdersScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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