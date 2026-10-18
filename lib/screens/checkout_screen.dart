import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/theme/app_colors.dart';
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isPlacingOrder = false;

  Future<void> placeOrder(
      BuildContext context,
      User user,
      List<QueryDocumentSnapshot> cartProducts,
      double total,
      ) async {
    if (isPlacingOrder) return;

    setState(() {
      isPlacingOrder = true;
    });

    try {
      // Cart items ko order items mein convert karna
      final List<Map<String, dynamic>> orderItems = [];

      for (final item in cartProducts) {
        final data = item.data() as Map<String, dynamic>;

        orderItems.add({
          'productId': data['productId'] ?? '',
          'productName': data['productName'] ?? '',
          'productPrice': double.parse(
            data['productPrice'].toString(),
          ),
          'quantity': data['quantity'] ?? 1,
        });
      }

      // Firestore mein order create karna
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'customerEmail': user.email ?? '',
        'items': orderItems,
        'totalAmount': total,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Order create hone ke baad cart empty karna
      final cartReference = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      for (final item in cartProducts) {
        await item.reference.delete();
      }

      if (!mounted) return;

      setState(() {
        isPlacingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Order placed successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Checkout screen se wapas Cart par
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isPlacingOrder = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to place order: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.shopping_cart_checkout),
            SizedBox(width: 10),
            Text(
              'Checkout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: user == null
          ? const Center(
        child: Text(
          'User not logged in',
          style: TextStyle(fontSize: 18),
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
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
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Cart is empty',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final cartProducts = snapshot.data!.docs;

          double total = 0;

          for (final item in cartProducts) {
            final data =
            item.data() as Map<String, dynamic>;

            final price = double.parse(
              data['productPrice'].toString(),
            );

            final quantity =
            int.parse(data['quantity'].toString());

            total += price * quantity;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor:
                          AppColors.darkGreen,
                          child: Icon(
                            Icons.person,
                            color: AppColors.lime,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.email ??
                                    'No email',
                                style:
                                const TextStyle(
                                  color: AppColors.lime,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                ...cartProducts.map((item) {
                  final data = item.data()
                  as Map<String, dynamic>;

                  final price = double.parse(
                    data['productPrice'].toString(),
                  );

                  final quantity = int.parse(
                    data['quantity'].toString(),
                  );

                  final itemTotal =
                      price * quantity;

                  return Card(
                    elevation: 4,
                    margin:
                    const EdgeInsets.only(
                      bottom: 10,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading:
                      const CircleAvatar(
                        backgroundColor:
                      AppColors.darkGreen,
                        child: Icon(
                          Icons.shopping_bag,
                          color: AppColors.lime,
                        ),
                      ),
                      title: Text(
                        data['productName']
                            ?.toString() ??
                            'Product',
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Price: ${price.toStringAsFixed(2)}'
                            '\nQuantity: $quantity',
                      ),
                      trailing: Text(

                        itemTotal
                            .toStringAsFixed(2),
                        style:
                        const TextStyle(
                          color: AppColors.darkGreen,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),

                Card(
                  elevation: 7,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        const Text(
                          'Total Bill',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        Text(
                          total.toStringAsFixed(2),
                          style:
                          const TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: isPlacingOrder
                        ? null
                        : () {
                      placeOrder(
                        context,
                        user,
                        cartProducts,
                        total,
                      );
                    },
                    icon: isPlacingOrder
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                      CircularProgressIndicator(
                        color: AppColors.lime,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(
                      Icons.check_circle,
                    ),
                    label: Text(
                      isPlacingOrder
                          ? 'Placing Order...'
                          : 'Place Order',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.darkGreen,
                      foregroundColor:
                      Colors.white,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}