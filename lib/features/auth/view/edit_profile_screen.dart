import 'dart:io';
import 'package:allergy_helper_project/core/functions/custom_snack_bar.dart';
import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override// returns a new instance of the EditProfileScreenStatej
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  File? _profileImage; //store photo for profile and will be updated when the user uploads a new profile image.
  bool _isLoading = false;//check if an asynchronous operation (uploading data, fetching user info) is in progress.

  final FirebaseAuth _auth = FirebaseAuth.instance;//access to Firebase Authentication for managing user sign-in and user data.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;//Accesses Firebase Firestore for storing and retrieving user profile data.
  final FirebaseStorage _storage = FirebaseStorage.instance;//Handles uploading and retrieving files of profile images from Firebase Storage.

  @override
  void initState() {
    _usernameController.text =//This pre-fills a TextField with the current username value when the widget is displayed.
        context.read<AppAuthProvider>().userModel!.username;//username is a specific field in the userModel that represents the user's username. and !  check the data is not null.

    super.initState();//ensure any initialization logic in the parent class State<..> is also executed.
  }

  Future<void> _pickImage() async {//the method open the device's gallery, allow the user to select an image, and then update the state of the widget with the selected image.
    final ImagePicker picker = ImagePicker();//The instance is used to interact with the device's media storage.
    final XFile? pickedFile =//returns an XFile object if a photo is selected, or null if nothing is chosen.
        await picker.pickImage(source: ImageSource.gallery);//Specifies that the image should be picked from the gallery.
    if (pickedFile != null) {//if the user selected one it will enter the if and if not it will skip.
      setState(() {
        _profileImage = File(pickedFile.path);//The _profileImage variable is updated with the selected image's file path, wrapped as a File object.
      });
    }
  }

  Future<String?> _uploadProfileImage(File image) async {//Future refers to String (the download URL) if the upload is successful, or null if it fails. the file image is uploaded.
    try {
      final User? user = _auth.currentUser;
      if (user == null) return null;//If no user is signed in, the method returns null immediately, as there is no user to associate the image with.

      final Reference storageRef = _storage
          .ref()//Accesses the root of Firebase Storage.
          .child('profile_images')//Creates a folder in Firebase Storage to store profile pictures.
          .child('${user.uid}-${DateTime.now()}.jpg');//Creates a unique file name for the uploaded image using the user's uid and the current timestamp. making each image unique so no overright happens.
      await storageRef.putFile(image);//Uploads the image file and Waits for the upload operation to complete before proceeding.
      print("download url: ${storageRef.getDownloadURL()}");
      return await storageRef.getDownloadURL();//Retrieves the download URL of the uploaded file, allowing the app or user to access the image. and Returns the download URL if the upload is successful.
    } catch (e) {
      debugPrint("Error uploading profile image: $e");//Logs the error to the console for.
      return null;//If an error occurs, the method returns null to indicate the failure.
    }
  }
        //** user name check.
  Future<void> _saveProfile() async {
    final isUsernameAllowed = await context
        .read<AppAuthProvider>()//A method that likely checks the database to ensure the given username is not already in use.
        .checkUserName(_usernameController.text.trim());//Gets the text from the username input field.
    final isTheCurrentUsername = _usernameController.text ==//controler is The username entered by the user. and the == ensures that the user can save their profile even if they haven't changed their username.
        context.read<AppAuthProvider>().userModel!.username;//Retrieves the current username of the user.
    if (!isUsernameAllowed && !isTheCurrentUsername) {//if username is taken and the entered one dont match the current. and If both conditions are true, the username is invalid.
      if (context.mounted) {//Ensures that the context is still valid before UI actions.
        customSnackBar(context, "Username is already taken");
      }
      return;//Stops further execution.
    }
    setState(() {//updating the widget state. 
      _isLoading = true;//true means the loading process has started (saving the profile).
    });

    final User? user = _auth.currentUser;
    if (user != null) {//Ensures a user is logged in before proceeding. 
      String? imageUrl;//Declares a nullable string variable to store the download URL of the uploaded profile image.
      if (_profileImage != null) {//Checks if a new profile image is selected (_profileImage holds the file to be uploaded).
        imageUrl = await _uploadProfileImage(_profileImage!);//The function returns the download URL of the uploaded image.
      }
      //refers to the firestore coliction users and the doc uid an img url.
      await _firestore.collection('users').doc(user.uid).update({
        'username': _usernameController.text,//Updates the username field with the value from _usernameController.
        if (imageUrl != null) 'photoUrl': imageUrl,//updates the photoUrl field only if imageUrl is not null. this make sure it updates only if theres a photo.
      });

      if (context.mounted) {
        customSnackBar(context, "Profile updated successfully");
        context.read<AppAuthProvider>().fetchUserModelData();//Calls a method to refresh the user's data in the app's state.
        Navigator.pop(context);
      }
    }

    setState(() {
      _isLoading = false;//false indicates that the profile-saving process is complete.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading//confition.
            ? const Center(child: CircularProgressIndicator())//if true.
            : Column(//if false.
                children: [
                  GestureDetector(//acts as an invisible widget that wraps around other widgets to provide gesture functionality.
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : NetworkImage(//class that fetches an image from a network URL.
                              _auth.currentUser?.photoURL ??//if it isnt null return the left.
                                  'https://via.placeholder.com/150',//if null return this as the knew photo.
                            ) as ImageProvider,
                      child: const Icon(Icons.camera_alt, size: 30),
                    ),
                  ),
                  const SizedBox(height: 20),//** box of user name.
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
      ),
    );
  }
}
