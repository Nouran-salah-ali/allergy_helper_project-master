import 'package:allergy_helper_project/core/functions/custom_snack_bar.dart';
import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/auth/view/widgets/custom_auth_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordOneController = TextEditingController();//for the new  pass
  final TextEditingController _passwordTwoController = TextEditingController();//for conferming the new pass

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),//app bar 
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        child: Column(//behined each other
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAuthField(//send requier text and the firt controller which was defined as texteditingcontroller
              text: "Password",
              controller: _passwordOneController,
            ),
            const SizedBox(height: 16.0),
            CustomAuthField(//send requier text and the firt controller which was defined as texteditingcontroller
              text: "Confirm Password",
              controller: _passwordTwoController,
            ),
            const SizedBox(height: 32.0),

            ElevatedButton(//button for changing the password
              style: ElevatedButton.styleFrom(//custonizinng the style for the button
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
              onPressed: () async {//when pressed 
              // Step 1: Check if the new password and confirm password match
                if (_passwordOneController.text ==
                        _passwordTwoController.text &&
                    _passwordTwoController.text.isNotEmpty) {//that the confirm password is not empty
                 // Step 2: Call the changePassword function to update the password
                  await context// await : function will wait for a result from the changePassword method before proceeding.
                      .read<AppAuthProvider>()// instance of the AppAuthProvider from the widget's context.
                      .changePassword(_passwordOneController.text);// pass in the new password 

                  if (context.mounted) {//if the widget is still avallibal
                    customSnackBar(context, "Password changed successfully");//inform user that it changed
                    Navigator.pop(context);
                  }
                } else {//if new pass is not ==conforming and conforming is empty
                  customSnackBar(context, "Check your passwords please");
                }
              },
              child: Text("Change password"),
            ),
          ],
        ),
      ),
    );
  }
}
