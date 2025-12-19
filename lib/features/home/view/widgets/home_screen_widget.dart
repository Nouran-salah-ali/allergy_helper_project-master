import 'package:allergy_helper_project/core/functions/custom_dialog.dart';
import 'package:allergy_helper_project/core/functions/custom_snack_bar.dart';
import 'package:allergy_helper_project/features/product/logic/product_provider.dart';
import 'package:allergy_helper_project/features/product/view/widgets/products_recommendation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors/app_colors_light.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) { /* context is used to access provider + 
  - selectedAllergies: it reads the list of the allergies the user selected from product provider class; 
  and .read is used here so it can get the data there without the widget getting rebuild over again.
  */
    final userAllergiesList = context.read<ProductProvider>().selectedAllergies;
/* we use it so its easier for us to make text already init or assign a value
  or use it for .Listen; and the reason we used is so its easier and more efficent to navigate throgh the app
  using programing.
  */ 
    final productCodeController = TextEditingController();
    return Column(
      children: [
        Expanded(//this widget should expand to fill the available space along the main axis.
          child: ProductsRecommendation(), // calling class recomand so it is displayed on screen.
        ),
        //**create the 
        //Alert Dialog */
        TextButton(//**for enter code manually */
          onPressed: () {//show box dialog when text of button is pressed
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(//**alert dialog is the name of the small box message/create the manually box**.
                  title: Text("Enter code"),
                  content: Column(//MainAxisSize.min: The Column will only be as tall as needed to fit the kids.
                    mainAxisSize: MainAxisSize.min,
                    //CrossAxisAlignment.stretch will stretch horizontally to fill the column's width.
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField( //the empty space that the user will insert the barcode in.
                        controller: productCodeController,
                        decoration: InputDecoration(//**dicoretion for the manually box**
                          filled: true,
                          fillColor: Colors.grey[200],
                          //Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide( //the ?? oprater check that the left side if the color is not null then it will use it.
                                color: Colors.grey[200] ?? Colors.grey), //the left side is a defult acting as a safty net if its null 
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Colors.grey[200] ?? Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /**check if proudect is save to consume or not
                   *  based on allergys
                   */
                  actions: [
                    TextButton(//**this is the search Button,lapled search**
                      onPressed: () async {
                        try {
                          //**check if there is value in text box, if so will look at products collection to find value crossponeded to it */
                          if (productCodeController.text.isNotEmpty) { 
                            DocumentSnapshot productSnapshot = // Find the product in the Firestore to check allergens
                                await FirebaseFirestore.instance 
                                    .collection('products') // products collection in Firestore
                                    .doc(productCodeController.text) //If user enters "12345" in the TextField, this will look for a document with the ID "12345" in the products collection.*/
                                    .get(); //Returns a DocumentSnapshot, data or not exist.
                                    
                            // if Doc exists, well convert info into Map to work with it on dart, and will make list for the allergys
                            if (productSnapshot.exists) {
                              Map<String, dynamic> productData = productSnapshot //will take data from the proudect that we just took above
                                  .data() as Map<String, dynamic>;//data in Firestore is dynamic, it's necessary to explicitly cast it to a map in order to work with it properly in Dart.
                                  //data() method returns this data as a Map<String, dynamic>, where Key is string"Proudects" and Value is ""
                              List<String> productAllergens =
                                  List<String>.from(productData['allergens']);//converts the allergens field of the productData into a List<String>

                              
                              if (context.mounted) { //mounted is used to make sure the widget is still active, make sure there will be no error when we do the next action like in here
                                
                                productCodeController.clear();//Clear the text from the textfiled of AllertDialog
                                Navigator.pop(context); //closes the current screen to return to the screen before

                                /* loop on allergys of user that has been selected,
                                checks if it is missing from productAllergens,
                                If all allergens are missing, proudec is save to cunsume 
                                Check if the product is safe*/
                                bool isSafe = userAllergiesList.every(// every will return true if the conditions met for every elem in list
                                    (allergy) =>
                                        !productAllergens.contains(allergy));//productAllergens: allergys of the proudect,allergy: for the user 
                                        //eg: egg - egg = true , ! will make it false , so proudect is not save cuz will not return true
                                final allergens=productAllergens;//varibla saved inside it all allergens in product

                                if (isSafe) {//we have NONE allergys
                                  customShowDialog(//custom method used to display a dialog
                                    context: context,
                                    title: "Safe to consume",//*display of the allertdialog**
                                    content: productData['name'],//name of Product from Data base
                                    subtitle: Text("Allergens: ${allergens.join(', ')}",//**title displaed+color for the allert */
                                      style: TextStyle(color: const Color.fromARGB(255, 116, 8, 8)),),
                                    icon: FaIcon(
                                      FontAwesomeIcons.check,//**Icon of ✓ */
                                      color: Colors.green,
                                      size: 32.0,
                                    ),
                                  );
                                } else {//Not SAVE
                                  customShowDialog(
                                    context: context,
                                    title: "Allergen detected!",// **title **
                                    content: productData['name'],
                                    subtitle: Text("Allergens: ${allergens.join(', ')}",
                                      style: TextStyle(color: const Color.fromARGB(255, 116, 8, 8)),),
                                    icon: FaIcon(
                                      FontAwesomeIcons.xmark,//**Icon of X */
                                      color: Colors.red,
                                      size: 32.0,
                                    ),
                                  );
                                }
                              }
                            } else {// if proudect not found in data base
                              if (context.mounted) {// ensures that the widget is still part of the widget
                                customShowDialog(
                                  context: context,
                                  title: "Product not found",//**Prouduct not found */
                                  content:
                                      "This product is not in the database.",
                                  icon: FaIcon(
                                    FontAwesomeIcons.exclamation,
                                   color: Colors.amber,
                                    //color: AppColorsLight.primaryColor,
                                    size: 32.0,
                                  ),
                                );
                              }
                            }
                          }
                        } catch (e) {//handle any pottentail errors,might occur during the product search or data fetching process
                          if (context.mounted) {
                            customSnackBar(context, "Barcode error");// snackbar is a short, temporary message that appears at the bottom of the screen to inform the user 
                          }
                        }
                      },
                      child: Text("Search"),//**the name of the sarch on the Dialog */
                    ),
                  ],
                );
              },
            );
          },
          child: Text("Enter product code manually"),//**for code to be entered manually */
        ),
      ],
    );
  }
}
