
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/theme/app_colors.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: AppColors.white,
        title: const Row(
          children: [
            Icon(Icons.receipt_long),
            SizedBox(width: 10),
            Text(
              'My Orders',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: user == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
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
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: AppColors.darkGreen,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No Orders Yet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your placed orders will appear here',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              const padding = 15.0;
              const spacing = 15.0;

              final availableWidth =
                  constraints.maxWidth - padding * 2;

              // Laptop: 3 columns
              // Mobile/tablet: 2 columns when space allows
              // Very narrow screens: 1 column
              final int columns =
              availableWidth >= 900
                  ? 3
                  : availableWidth >= 340
                  ? 2
                  : 1;

              final cardWidth =
                  (availableWidth -
                      spacing * (columns - 1)) /
                      columns;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: orders.map((order) {
                    final data =
                    order.data() as Map<String, dynamic>;

                    final totalAmount =
                        double.tryParse(
                          data['totalAmount'].toString(),
                        ) ??
                            0.0;

                    final status =
                        data['status']?.toString() ??
                            'Pending';

                    final items =
                        data['items'] as List<dynamic>? ?? [];

                    final createdAt = data['createdAt'];

                    String orderDate = 'Date not available';

                    if (createdAt is Timestamp) {
                      final date = createdAt.toDate();
                      orderDate =
                      '${date.day}/${date.month}/${date.year}';
                    }

                    return SizedBox(
                      width: cardWidth,
                      child: Card(
                        color: AppColors.white,
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                alignment:
                                WrapAlignment.spaceBetween,
                                crossAxisAlignment:
                                WrapCrossAlignment.center,
                                children: [
                                  const Text(
                                    'Order',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreen,
                                      borderRadius:
                                      BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Text(
                                      status,
                                      style: const TextStyle(
                                        color:
                                        AppColors.darkGreen,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                'Order ID: ${order.id}',
                                style: const TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                'Date: $orderDate',
                                style: const TextStyle(
                                  color: AppColors.darkGreen,
                                ),
                              ),

                              const Divider(height: 25),

                              const Text(
                                'Products',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              ...items.map((item) {
                                final itemData =
                                item as Map<String, dynamic>;

                                final name =
                                    itemData['productName']
                                        ?.toString() ??
                                        'Product';

                                final quantity =
                                    itemData['quantity']
                                        ?.toString() ??
                                        '1';

                                final price =
                                    double.tryParse(
                                      itemData['productPrice']
                                          .toString(),
                                    ) ??
                                        0.0;

                                return Padding(
                                  padding:
                                  const EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '$name × $quantity',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        price.toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              const Divider(height: 25),

                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                totalAmount.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
