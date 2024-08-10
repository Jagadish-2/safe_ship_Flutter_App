import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_ship/Screens/home_screen.dart';
import 'package:safe_ship/Screens/payment_method_screen.dart';
import 'package:safe_ship/Screens/payment_suscess_screen.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    super.initState();
  }
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('safe_ship App') // Adjust to your collection name
        .doc(productId)
        .get();

    if (!productSnapshot.exists) {
      return {};
    }

    return productSnapshot.data()!;
  }

  Future<Map<String, dynamic>> getCartData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return {};
    }

    final cartSnapshot =
        await FirebaseFirestore.instance.collection('carts').doc(userId).get();

    if (!cartSnapshot.exists) {
      return {};
    }

    return cartSnapshot.data()!;
  }

  Future<void> removeProductFromCart(String productId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final cartRef = FirebaseFirestore.instance.collection('carts').doc(userId);
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.exists) {
      final cartData = cartSnapshot.data()!;
      if (cartData.containsKey(productId)) {
        cartData.remove(productId);
        await cartRef.set(cartData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.navigateToScreen(child: HomeScreen());
          },
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCartData(),
        builder: (context, cartSnapshot) {
          if (cartSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!cartSnapshot.hasData || cartSnapshot.data!.isEmpty) {
            return  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cart is empty, add items to continue shoping',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/cart.png'),
              ],
            ));
          }

          final cartData = cartSnapshot.data!;
          final productIds = cartData.keys.toList();
          final quantities = Map.from(cartData);

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: Future.wait(
              productIds.map((productId) => getProductDetails(productId)),
            ),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                return Center(child: Text('No products found'));
              }

              final products = productSnapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final productId = productIds[index];
                        final product = products[index];
                        final quantity = quantities[productId]['quantity'];
                        final name = quantities[productId]['name'];
                        final imageUrl =
                            quantities[productId]['imageUrl'] ?? '';

                        return ListTile(
                          leading: Image.network(
                            imageUrl.isNotEmpty
                                ? imageUrl
                                : 'https://via.placeholder.com/150',
                            // Fallback image
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                  Icons.error); // Handle image loading error
                            },
                          ),
                          title: Text(name ?? 'No name'),
                          subtitle: Text(
                              'Price: ₹${quantities[productId]['price'] * quantity}'),
                          trailing: Column(
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    removeProductFromCart(productId);
                                  },
                                ),
                              ),
                              Text('Qty: $quantity'),
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(8.0),
                          isThreeLine: true,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(36)),
                        child: const Center(
                            child: Text(
                          'continue to payment',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                      ),
                      onTap: () {
                        context.navigateToScreen(child: paymentMethodScreen());
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
