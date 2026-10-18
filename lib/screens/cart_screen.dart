import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/theme/app_colors.dart';
import 'checkout_screen.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: AppColors.white,

        title: const Row(
          children: [
            Icon(Icons.shopping_cart),
            SizedBox(width: 10),
            Text(
              "Cart",
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
            .collection('cart')
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

          // ================= EMPTY CART =================
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Cart is empty",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Add some products to your cart",
                    style: TextStyle(
                      color: AppColors.lime,
                    ),
                  ),
                ],
              ),
            );
          }

          final cartProducts =
              snapshot.data!.docs;

          // ================= TOTAL =================
          double total = 0;

          for (final item in cartProducts) {
            final price = double.parse(
              item['productPrice'].toString(),
            );

            final quantity =
            item['quantity'] as int;

            total += price * quantity;
          }

          return Column(
            children: [
              // ================= CART PRODUCTS =================
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),

                  itemCount: cartProducts.length,

                  itemBuilder: (context, index) {
                    final item =
                    cartProducts[index];

                    final price = double.parse(
                      item['productPrice']
                          .toString(),
                    );

                    final quantity =
                    item['quantity'] as int;

                    final itemTotal =
                        price * quantity;

                    return Card(
                      elevation: 6,

                      margin: const EdgeInsets.only(
                        bottom: 6,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),

                      child: Padding(
                        padding:
                        const EdgeInsets.all(15),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            // ================= PRODUCT NAME =================
                            Text(
                              item['productName'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ================= PRICE & TOTAL =================
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                              children: [
                                Text(
                                  "Price: ${price.toStringAsFixed(2)}",
                                  style:
                                  const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.lime,
                                  ),
                                ),

                                Text(
                                  "Total: ${itemTotal.toStringAsFixed(2)}",
                                  style:
                                  const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.bold,
                                    color:
                                    AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // ================= BOTTOM ROW =================
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                              children: [
                                // Quantity controls
                                Container(
                                  decoration:
                                  BoxDecoration(
                                    border: Border.all(
                                      color:
                                    AppColors.lime,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(12),
                                  ),

                                  child: Row(
                                    children: [
                                      // MINUS
                                      IconButton(
                                        onPressed: () async {
                                          if (quantity >
                                              1) {
                                            await item
                                                .reference
                                                .update({
                                              'quantity':
                                              quantity -
                                                  1,
                                            });
                                          }
                                        },

                                        icon: const Icon(
                                          Icons.remove,
                                        ),

                                        color:
                                       AppColors.darkGreen
                                      ),

                                      // QUANTITY
                                      Text(
                                        "$quantity",
                                        style:
                                        const TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),

                                      // PLUS
                                      IconButton(
                                        onPressed: () async {
                                          await item
                                              .reference
                                              .update({
                                            'quantity':
                                            quantity +
                                                1,
                                          });
                                        },

                                        icon: const Icon(
                                          Icons.add,
                                        ),

                                        color:
                                        AppColors.darkGreen
                                      ),
                                    ],
                                  ),
                                ),

                                // DELETE
                                IconButton(
                                  onPressed: () async {
                                    await item
                                        .reference
                                        .delete();
                                  },

                                  icon: const Icon(
                                    Icons.delete,
                                  ),

                                  color: Colors.red,
                                  iconSize: 28,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
                  SizedBox(
                    height: 10,
                  ),
              // ================= TOTAL BILL CARD =================
              Card(
                elevation: 10,

                margin: const EdgeInsets.all(10),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [
                          const Text(
                            "Total Bill",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          Text(
                            total.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight:
                              FontWeight.bold,
                              color: AppColors.darkGreen
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // ================= CHECKOUT =================
                      SizedBox(
                        width: 200,
                        height: 50,

                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutScreen(),
                              ),
                            );
                          },

                          icon: const Icon(
                            Icons.shopping_cart_checkout,
                          ),

                          label: const Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}