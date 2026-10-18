import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/screens/products_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/theme/app_colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> addProduct() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final productRef =
    FirebaseFirestore.instance.collection('products').doc();

    await productRef.set({
      'docId': productRef.id,
      'name': nameController.text.trim(),
      'price': priceController.text.trim(),
      'description': descriptionController.text.trim(),
      'userId': user.uid,
    });

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductsScreen(),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APP BAR =================
      appBar: AppBar(
       backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        title: const Text(
          "Add Product",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 12,

            margin: const EdgeInsets.all(25),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Padding(
              padding: const EdgeInsets.all(30),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ================= HEADING =================
                  const Text(
                    "Add New Product",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Enter product details below",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.lime,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= PRODUCT NAME =================
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      prefixIcon: const Icon(
                        Icons.shopping_bag,
                        color: AppColors.darkGreen,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.darkGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ================= PRICE =================
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      labelText: "Price",
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: AppColors.darkGreen,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.darkGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ================= DESCRIPTION =================
                  TextField(
                    controller: descriptionController,
                    maxLines: 5,

                    decoration: InputDecoration(
                      labelText: "Description",
                      alignLabelWithHint: true,

                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 70),
                        child: Icon(
                          Icons.description,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.darkGreen,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= ADD BUTTON =================
                  SizedBox(
                    width: 220,
                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: addProduct,

                      icon: const Icon(
                        Icons.add,
                      ),

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

                        elevation: 5,

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
      ),
    );
  }
}