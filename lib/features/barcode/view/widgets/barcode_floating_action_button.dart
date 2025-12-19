import 'package:allergy_helper_project/core/functions/custom_dialog.dart';
import 'package:allergy_helper_project/core/functions/custom_snack_bar.dart';
import 'package:allergy_helper_project/features/product/logic/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*StatefulWidget for scann */
class BarcodeFloatingActionButton extends StatefulWidget {
  const BarcodeFloatingActionButton({super.key});

  @override
  State<BarcodeFloatingActionButton> createState() =>
      _BarcodeFloatingActionButtonState();
}//class

class _BarcodeFloatingActionButtonState
    extends State<BarcodeFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final userAllergiesList = context.read<ProductProvider>().selectedAllergies;

    //final allergens = product['allergens'];
    return FloatingActionButton(
      //icon for barcode
      child: Icon(FontAwesomeIcons.barcode),
      onPressed: () async {
        try {
          //create instance of barcode
          final barcode = await BarcodeScanner.scan();
          //instance od contante wich is id of product
          final barcodeContent = barcode.rawContent;

          if (barcodeContent.isNotEmpty) {
            // Find the product in the Firestore to check allergens
            /*find in database product with id same to barcode content*/
            DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
                .collection('products')
                .doc(barcodeContent)
                .get();


            if (productSnapshot.exists) {
              //list of product data
              Map<String, dynamic> productData =
                  productSnapshot.data() as Map<String, dynamic>;
              //list of productAllergens i take it from product data
              List<String> productAllergens =
                  List<String>.from(productData['allergens']);

              // Check if the product is safe
              /* mounted  this context is associated with is currently mounted in the widget tree.*/
              if (context.mounted) {
                //if there is no match means it is safe
                bool isSafe = userAllergiesList
                    .every((allergy) => !productAllergens.contains(allergy));

                //save all allergens in product in variable to use it in coustom show dialog
                final allergens=productAllergens;

                if (isSafe) {
                  //************************************************
                  //Safe to consume
                  customShowDialog(
                    context: context,
                    title: "Safe to consume",
                    content: productData['name'],
                    subtitle: Text("Allergens: ${allergens.join(', ')}",
                      style: TextStyle(color: Colors.redAccent),),
                    icon: FaIcon(
                      FontAwesomeIcons.check,
                      color: Colors.green,
                      size: 32.0,
                    ),
                  );
                }
                else {
                  //****************************************
                  //Allergen detected
                  customShowDialog(

                    context: context,
                    title: "Allergen detected!",
                    content: productData['name'],
                    subtitle: Text("Allergens: ${allergens.join(', ')}",
                      style: TextStyle(color: Colors.redAccent),),
                    icon: FaIcon(
                      FontAwesomeIcons.xmark,
                      color: Colors.red,
                      size: 32.0,
                    ),
                  );

                  //***************************************************************
                }
              }
            } else {
              /*if (context.mounted) is a check to ensure that the context
              (which represents the widget's location in the widget tree) is still valid user still in same location
               and first condition did not pass and second means product not found*/
              if (context.mounted) {
                customShowDialog(
                  context: context,
                  title: "Product not found",
                  content: "This product is not in the database.",
                  icon: FaIcon(
                    FontAwesomeIcons.exclamation,
                    color: Colors.amber,
                    size: 32.0,
                  ),
                );
              }
            }
          }//barcodeContent.isNotEmpty
        }//try
        catch (e) {
          if (context.mounted) {
            customSnackBar(context, "Barcode error!");
          }
        }//catch
      },//on press
    );
  }//widget build
}//class
