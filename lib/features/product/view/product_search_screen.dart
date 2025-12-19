import 'package:allergy_helper_project/core/functions/custom_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ProductSearchScreenState createState() => ProductSearchScreenState();
}//ProductSearchScreen

class ProductSearchScreenState extends State<ProductSearchScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = false;

  // Instead of using a text controller
  String _query = "";
/*Updates the _query with the current search input.
Sets _isLoading to true if the query is not empty.*/
  void _searchProducts(String query) async {
    setState(() {
      _query = query;
      _isLoading = query.isNotEmpty;
    });

    if (query.isEmpty) {
      setState(() {
        ///clean list
        _filteredProducts = [];
        _isLoading = false;
      });
      return;
    }//if

    try {
      /*If _allProducts is empty (first-time search),
       fetches all products from the products collection in Firestore.*/
      if (_allProducts.isEmpty) {
        //get all data
        final QuerySnapshot snapshot =
            await _firestore.collection('products').get();
        //detalis of product
        final products = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();

        setState(() {
          _allProducts = products;
        });
      }//if

      final filtered = _allProducts
      //product object from _allProducts
      //if product name equal to input user wich is query or
      //allergy equial to quiry
          .where((product) =>
              product['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              product['allergens']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
      //return list of matched
          .toList();

      setState(() {
        //all matched product is here and loading false because i finshede
        _filteredProducts = filtered;
        _isLoading = false;
      });
    }//try
    catch (e) {
      if (context.mounted) {
        customSnackBar(context, "Error searching products: $e");
      }//if
      setState(() {
        _isLoading = false;
      });
    }//catch
  }//_searchProducts
//**********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          // Search Text Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchProducts,
              decoration: InputDecoration(
                hintText: "Search for a product...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          // Search Results or Message
          Expanded(
            child: _query.isEmpty
                ? const Center(
                    child: Text("Start typing to search for products..."),
                  )
                : _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredProducts.isEmpty
                        ? const Center(
                            child: Text("No products found"),
                          )
                        : ListView.builder(
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              final name = product['name'];
                              final image = product['image'];
                              final allergens = product['allergens'];

                              return ListTile(
                                leading: image != null
                                    ? Image.network(
                                        image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image),
                                title: Text(name),
                                subtitle:
                                    Text("Allergens: ${allergens.join(', ')}"),
                              );
                            },//itemBuilder
                          ),
          ),
        ],//children
      ),
    );
  }//build
}//ProductSearchScreenState
