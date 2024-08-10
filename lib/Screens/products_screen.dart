import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_ship/Widgets/navigation_widget.dart';

import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final CollectionReference productData =
      FirebaseFirestore.instance.collection("safe_ship App");

  List<String> categories = ["Electronics", "Clothing", "Groceries", "Books"];

  @override
  Widget build(BuildContext context) {
    GestureDetector ItemDiaplay(
        BuildContext context, DocumentSnapshot<Object?> documentSnapshot) {
      return GestureDetector(
        onTap: () {
          context.navigateToScreen(
              child: DetailsScreen(documentSnapshot: documentSnapshot));
        },
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: documentSnapshot['imageurl'],
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                          documentSnapshot['imageurl'],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  documentSnapshot['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            documentSnapshot['rating'.toString()],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "\₹ ${documentSnapshot['price'].toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          const SizedBox(height: 20),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Aligns widgets at the ends
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Safe Ship",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:Icon(
                    Icons.shopping_bag,
                    size: 30,
                  ),

              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/safe-ship-34660.appspot.com/o/images%2Fiphone.png?alt=media&token=500e8d6f-9d37-4a3d-afcf-74889bf28ac6",
                  height: 160,
                  width: 160,
                ),
                const SizedBox(width: 10),
                const Column(
                  children: [
                    Text(
                      "Featured Product",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Clearance Sale!!!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: productData.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.79),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return ItemDiaplay(context, documentSnapshot);
                      });
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    ]));
  }
}

class DetailsScreen extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const DetailsScreen({super.key, required this.documentSnapshot});

  Future<void> addToCart(String productId, int quantity) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final cartRef = FirebaseFirestore.instance.collection('carts').doc(userId);
    final productsRef =
        FirebaseFirestore.instance.collection('safe_ship App').doc(productId);

    try {
      // Retrieve product details
      final productSnapshot = await productsRef.get();
      if (!productSnapshot.exists) {
        print('Product not found');
        return;
      }

      final productData = productSnapshot.data();
      final imageUrl = productData?['imageurl'];
      final name = productData?['name'];
      final price = productData?['price'];

      // Add or update the product in the cart
      await cartRef.set({
        'items.$productId': {
          'quantity': FieldValue.increment(quantity),
          'imageUrl': imageUrl,
          'name': name,
          'price': price,
        },
      }, SetOptions(merge: true)).catchError(
          (e) => print('Error updating cart: $e'));
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String productId = documentSnapshot.id;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          Stack(
            children: [
              Hero(
                tag: documentSnapshot['imageurl'],
                child: Image.network(
                  documentSnapshot['imageurl'],
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              const BackButton()
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  documentSnapshot['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\₹ ${documentSnapshot['price']}",
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.star,
                      color: Colors.amber[900],
                    ),
                    Text(
                      documentSnapshot['rating'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "${documentSnapshot['review']}(review)",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  documentSnapshot['description'],
                  maxLines: 7,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      height: 75,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 2,
                            color: documentSnapshot['isfavorite'] == true
                                ? Colors.red
                                : Colors.black),
                      ),
                      child: Icon(Icons.favorite,
                          size: 45,
                          color: documentSnapshot['isfavorite'] == true
                              ? Colors.red
                              : Colors.black),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Text(
                              'Add to cart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        onTap: () {
                          // Call addToCart with productId and desired quantity
                          addToCart(productId, 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Item added to cart"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
