import 'dart:io';
import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/auth/view/widgets/custom_auth_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
//***************************************************************************************
  /*_pickImage() method i  create save path of image in variable*/
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }//pick image
//*************************************************************************************
  Future<(String, bool)> register() async {
    //u can  nor register with out pick image
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    if (_selectedImage == null) {
      return ("Please select a profile picture 🖼️", false);
    }

    final isUsernameAllowed =
    //checkUserName method in auth provider
        await authProvider.checkUserName(usernameController.text.trim());
    if (isUsernameAllowed) {
      final result = await authProvider.createUserWithEmailAndPassword(//method in auth provider
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        _selectedImage!,
      );
      return result;
    }
    return ("Username is already existed 🥲", false);
  }//resister
  //***********************************************************************build
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _selectedImage != null
                      ? CircleAvatar(
                    backgroundImage: FileImage(_selectedImage!),
                    radius: 75,
                  )
                      : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                        Text("Profile Image", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),

              //***********************************************************************
              const SizedBox(height: 16),
              CustomAuthField(
                text: 'Enter your username',
                controller: usernameController,
              ),
              const SizedBox(height: 16),
              CustomAuthField(
                text: 'Enter your email',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomAuthField(
                text: 'Enter your password',
                controller: passwordController,
              ),
              const SizedBox(height: 48),
              //sign up
              ElevatedButton(
                onPressed: () async {
                  final (String message, bool success) = await register();
                  if (context.mounted) {
                    if (success) {
                      // Successful registration logic
                    } else {
                      //show eroor message as bar
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLight.primaryColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Sign up"),
              ),


              //*************************************************************have account ?????????
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(fontSize: 15),
                    ),
                    TextSpan(
                      text: "Sign in",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                        //from auth provider changeIsLogging() change is logg in
                          //wich is in auth screen tregire page register or log in
                          context.read<AppAuthProvider>().changeIsLogging();
                        },
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColorsLight.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }//build
}
