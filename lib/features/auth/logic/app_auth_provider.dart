import 'dart:io';
import 'package:allergy_helper_project/features/auth/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
/*Class manages user authentication and 
user data in a Flutter app using Firebase */

class AppAuthProvider extends ChangeNotifier {
  final _firebaseAuthInstance = FirebaseAuth.instance;//_firebaseAuthInstance: Provides authentication functionality (like signing in, creating a user, logging out).
  final _firebaseFireStoreInstance = FirebaseFirestore.instance;//_firebaseFireStoreInstance:  interaction with Firebase Firestore (for storing/retrieving user data).
  final _firebaseStorageInstance = FirebaseStorage.instance;//_firebaseStorageInstance: uploading user profile images to Firebase Storage.

/* declare the private field first, then the getter.************************************************************* */

/*user tupy data from fire base contain basic information about an authenticated user,
such as their uid (user ID), email, or displayName.*/
  User? _user;// Hold current user (if logged in), ?or be null (if no user is authenticated).
/*getter that provides read-only access to the private _user
* so if i want basic data about user i should gwt it from user getter*/
  User? get user => _user;// public getter for the private _user variable. It allows other parts of the app to access the current User

  bool isLogging = false;// track whether a user is currently in the process of logging in or logging out.
  /*_userModel: This is a private variable that holds an instance of UserModel
UserModel name of class i crated then i want to get constractor and save it is data in variable*/
  UserModel? _userModel;
/*
so if i want all data about user i should gwt it from usermodel getter*/
  UserModel? get userModel => _userModel;//Stores more detailed information about the user beyond what is provided by Firebase's User object.
  //For example, it might contain the user's username, profile picture URL, email, and other custom data.
//public getter for the _userModel variable. It allows other parts of the app to access the current UserModel

/*waiteing means user is null**************************************************************************/
  bool get isWaitingUserModel {//getter  checks whether the userModel is null or not.
    if (userModel == null) {//user’s detailed data has not been fetched yet or is unavailable
      return true;//returns true. This indicates that the app is still waiting for the user model to be available.
    }
    return false;
  }

  void changeIsLogging([bool? logging]) {//changing the isLogging
    isLogging = logging ?? !isLogging; //if it was false, it will become true
    notifyListeners();
  }
//************************************************************************************************************
  AppAuthProvider() {//constructor of the AppAuthProvider class
    _firebaseAuthInstance.authStateChanges().listen((User? user) {//listens for changes in the authentication state. In other words, 
    //whenever the authentication state of the user changes (such as logging in or out), this listener is triggered.
    //user parameter will contain the current user.If the user is logged in, it contains the user's information, if the user is logged out, it will be null
      _user = user;//user is then assigned to _user
      fetchUserModelData();//fetch the detailed user data from Firestore. Based on Id
    });
  }
//*****************************************************************************************************
  // retrieve detailed user data
  Future<void> fetchUserModelData() async {
    //Checks if there is a logged-in user.
    if (_firebaseAuthInstance.currentUser != null) {
      /*fetchUserData method we made return user model data*/
      _userModel = await fetchUserData(_firebaseAuthInstance.currentUser!.uid);
    }
    notifyListeners();
  }
//******************************************************************************************************
  // Create account using email and password
  Future<(String, bool)> createUserWithEmailAndPassword(

      String username,
      String email,
      String password,
      File pickedImage,
      ) async {
    try {
      final userCredential =
      //createUserWithEmailAndPassword build in
      await _firebaseAuthInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final storageRef = _firebaseStorageInstance
          .ref()
          .child('profile_images')
          .child('${userCredential.user!.uid}.jpg');
      await storageRef.putFile(pickedImage);
      final photoUrl = await storageRef.getDownloadURL();

      await _firebaseFireStoreInstance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': username,
        'photoUrl': photoUrl,
        'firstTimeLogging': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
//here i am saving  user data in user model successfully
      _userModel = await fetchUserData(userCredential.user!.uid);

      notifyListeners();
      return ("Success", true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ("The password provided is too weak.", false);
      } else if (e.code == 'email-already-in-use') {
        return ("The account already exists for that email.", false);
      }
    } catch (e) {
      debugPrint("");
      return ("Sign up with email and password error.", false);// for the debuge 
    }
    return ("Check your data and try again.", false);
  }//create user
//****************************************************************************************************************
  // Sign in using email and password
  Future<(String, bool)> loggingUsingEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      final userCredential =
      //sign in with email build in function
      await _firebaseAuthInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
//here i am saving  user data in user model successfully
      _userModel = await fetchUserData(userCredential.user!.uid);
      notifyListeners();
      return ("Success", true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ("User not found for this email.", false);
      } //if
      else if (e.code == 'wrong-password') {
        return ("Wrong username or password.", false);
      }
    } catch (e) {
      return ("Sign in with email and password error.", false);
    }
    return ("Check your data and try again.", false);
  }//log in
//****************************************************************************************************
  // Update user allergies in fire store
  //take allerges list user have as parameter
  Future<void> updateUserAllergiesOnDatabase(List<String> list) async {
    try {
      // retrieve the unique user ID (uid) of the currently authenticated user in a Firebase
      final userId = _firebaseAuthInstance.currentUser!.uid;
//update allergies in user database using set
      await _firebaseFireStoreInstance.collection('users').doc(userId).set({
        "allergies": list,
        //when i am updating rhat is mean i am not new user
        "firstTimeLogging": false,
      },
          SetOptions(merge: true));
      /*when i created new field in user collection i nees to retrive user model*/
      fetchUserModelData();
    } catch (e) {// if firebase has any problem updating
      print("Error saving preferences: $e");
    }
  }//update user allergy
//***************************************************************************************************
  Future<bool> checkUserName(String username) async {
    final result = await _firebaseFireStoreInstance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    //result.docs contains a list of documents that match the query
/*If result.docs.isNotEmpty:
This means there is at least one document where the username field matches the input username.
This indicates that the username is already in use.
Returning false signals that the username is not available.*/
    if (result.docs.isNotEmpty) {
      return false;//userid taken
    }
    return true;
  }
  //**************************************************************************************************
//** retrieves user data from a Firestore collection. It takes a String id (which presumably represents the user ID) 
//and attempts to fetch the user's data from the Firestore users collection. 
// If the document exists, it returns a UserModel populated with the data from Firestore. If the document doesn't exist, it returns null.*/
  Future<UserModel?> fetchUserData(String id) async {
    final DocumentSnapshot doc =
    //fetches a document from the users collection in Firestore, where the document ID is provided by the id parameter
    await _firebaseFireStoreInstance.collection('users').doc(id).get();
    print(doc.exists);// returns a boolean if exist or not
    print(doc.data());//returns the document data
     //***This line repeats the same Firestore fetch as the first one, which seems redundant and unnecessary. You can safely remove it without affecting the functionality. */
    //await _firebaseFireStoreInstance.collection('users').doc(id).get();

    if (doc.exists) {
      /*all user date in map*/
      final userData = doc.data() as Map<String, dynamic>;// data from the document is cast to a Map<String, dynamic>
      return UserModel(
        id: id,
        username: userData["username"],//username field from the document.
        email: userData["email"],
        profileUrl: userData["photoUrl"] ?? "",
        firstTimeLogging: userData["firstTimeLogging"] ?? false,
      );
    }
    return null;
  }//fetchUserData
//**************************************************************************************
  Future<void> resetPassword(String email) async {
    //send reset email build in func
    await _firebaseAuthInstance.sendPasswordResetEmail( email: email,);
  }
  //**************************************************************************************
  Future<void> changePassword(String password) async {
    try {

      //// Attempt to update the user's password in Firebase Authentication
      await _firebaseAuthInstance.currentUser!.updatePassword(password);// method provided by Firebase Authentication that updates the current user's password.

      debugPrint("password changed successfully");
    } catch (e) {//any error 
      debugPrint("error changing password");
    }
  }//change pass
//********************************************************************************************
  // Logout user from firebase
  void logout() {

    _userModel = null;//clears the user model, such as user data or profile
    isLogging = true;//its false by default, meaning the systme assumes that no logout operation is happening.

    //signOut build in function from firebase package,signs the user out of Firebase Authentication.
    _firebaseAuthInstance.signOut();
    //signOut() method is provided by Firebase to log the currently authenticated user out.
    notifyListeners();// you're informing any UI components that are dependent on the authentication state to update their display
  }





}//class auth








