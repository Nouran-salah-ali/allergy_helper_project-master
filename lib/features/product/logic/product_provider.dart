import 'package:allergy_helper_project/core/enum/request_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider extends ChangeNotifier {
  final _firebaseFirestoreInstance = FirebaseFirestore.instance;
  final _firebaseAuthInstance = FirebaseAuth.instance;
/*const map:
This means _allergies is immutable and cannot be changed after its definition.
You cannot add, remove, or modify entries in _allergies.*/
  static const Map<String, bool> _allergies = {
    'Egg': false,
    'Fish': false,
    'MSG': false,
    'Milk': false,
    'Gluten': false,
    'Soya': false,
    'Peanut': false,
    'Shrimp': false,
    'Cashew': false,
    'Celery': false,
    'Sesame Seeds': false,
    'Nothing': false,
  };
  //*****************************************
/*... it iterate original map and  save data to new map */
  Map<String, bool> allergies = {..._allergies};
/*get is like getter method in java give me access to get data from list
* selectedAllergies name of getter*/
  List<String> get selectedAllergies =>
  /*i will save inside get selected allergies
  use mab we created of allergies  and save   true values
  * because i want to collect all allergies are true in one list*/
      allergies.keys.where((key) => allergies[key] == true).toList();
//************************************************************
  List<Map<String, dynamic>> safeProducts = [];
//*******************************************************
  /*i am here give value true for ech allergy match allergy in user list*/
  Future<void> fetchAllergiesPreferences() async {
    //print if method is executing
    debugPrint("fetchAllergiesPreferences");
    //if user not null
    if (_firebaseAuthInstance.currentUser != null) {
      debugPrint("fetchAllergiesPreferences: _firebase instance is not null");
      //go to user collection and get it id and then get it is all data
      final result = await _firebaseFirestoreInstance
          .collection("users")
          .doc(_firebaseAuthInstance.currentUser!.uid)
          .get();
      /*if there is data and
      *  Checks if the document contains a key named allergies and that it is not null.*/
      if (result.data() != null && result.data()!["allergies"] != null) {
        /* Iterates through the list of allergies retrieved from Firestore.
        * allergy it is name for object in allergy document list */
        //*****************result.data()!["allergies"] cntain allergy user has ***********
        for (final allergy in result.data()!["allergies"] as List) {
          debugPrint("fetchAllergiesPreferences: there is allergies");
          //Updates the allergies map to mark the current allergy (allergy) as true.
          /*here i am just update allergy that in user document to true in list
          * in summary iam giving value true for every allergy in document user */
          allergies[allergy] = true;
        }//for
      }//if
    }//if user not null
  }//fetchAllergiesPreferences


//********************************************************************
// get recommendations products
  //RequestState loading done or error
  RequestState getRecommendationsRequestState = RequestState.loading;
  bool isUpdateRecommendations = false;
  /*If the recommendations have already been fetched (RequestState.done) and no update is needed*/
  Future<void> getRecommendations() async {
    if (getRecommendationsRequestState == RequestState.done &&
        !isUpdateRecommendations) return;
    getRecommendationsRequestState = RequestState.loading;
    safeProducts = [];
//list have allergy that have value true
    List<String> selectedAllergies =
        allergies.keys.where((key) => allergies[key] == true).toList();

    try {
      //get all products in collection
      QuerySnapshot productsSnapshot =
          await _firebaseFirestoreInstance.collection('products').get();

      for (var productDoc in productsSnapshot.docs) {
        //for each product while itreating document
        //Converts product data into a map (productData)
        Map<String, dynamic> productData =
            productDoc.data() as Map<String, dynamic>;
        //save all allergens  of  product in list using map we created
        List<String> productAllergens =
            List<String>.from(productData['allergens']);

        /*selectedAllergies is list we created and svaed true value in it and then chech for evry allergy select not equal to
        * any product allergy if this true meanse safe to eat*/
        //Checks if all selected allergies are not present in the product's allergen list using .every().
        bool isSafe = selectedAllergies
            .every((allergy) => !productAllergens.contains(allergy));
//and then add all safe products to list
        if (isSafe) {
          safeProducts.add(productData);
        }
      }
      getRecommendationsRequestState = RequestState.done;
      isUpdateRecommendations = false;
      notifyListeners();
    }//try
    catch (e) {
      debugPrint("error while fetching products");
      getRecommendationsRequestState = RequestState.error;
    }//catch

    notifyListeners();
  }//getRecommendations
//*********************************************************
  void updateRecommendations() {
    isUpdateRecommendations = true;
    getRecommendationsRequestState = RequestState.loading;
    notifyListeners();
    getRecommendations();
  }//updateRecommendations
  //************************************************allergies**true to false false to true
/*If allergies[allergy] is true, it becomes false.
If allergies[allergy] is false, it becomes true.
! after allergies[allergy]:
This is the null assertion operator, used to ensure the value is non-null (safe to toggle).*/
  void updateAllergiesStatus(String allergy) {
    //allergies
    allergies[allergy] = !allergies[allergy]!;
    /*Calls this method from ChangeNotifier to notify all listeners

     Consumer, Provider.of widgets that the allergies data has changed.*/
    notifyListeners();
  }//updateAllergiesStatus
//*****************************************************************
  void reset() {
    //copy all defult data from original list to new list
    allergies = {..._allergies};
  }//reset
}//ProductProvider
