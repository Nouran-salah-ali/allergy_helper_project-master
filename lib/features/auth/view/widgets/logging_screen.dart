import 'package:allergy_helper_project/core/functions/custom_snack_bar.dart';
import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/auth/view/widgets/custom_auth_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggingScreen extends StatelessWidget {
  const LoggingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController resetPasswordController = TextEditingController();
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

    Future<(String, bool)> logging() async {
      //method i created loggingUsingEmailAndPassword
      final result = await authProvider.loggingUsingEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      return result;
    }//logging

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CustomAuthField i created take email and password
          CustomAuthField(
            text: 'Enter your  email',
            controller: emailController,
          ),
          const SizedBox(height: 16),
          CustomAuthField(
            text: 'Enter your  password',
            controller: passwordController,
          ),
          const SizedBox(height: 48),

          //button sign in ****************************************
          ElevatedButton(
            onPressed: () async {
              /*logging method call log in that return login seccfuly or eroor */
              final result = await logging();
              /*ensures the widget is still active before interacting with the context*/
              if (context.mounted) {
                /*If result.$2 is true, nothing happens (the block is empty).
                  If result.$2 is false, it calls the customSnackBar() function
                   with the context and the first item from the result (result.$1). */
                /*if result rue every thing is good and log in else thare is problem
                * 2 return true or false 1 return message*/
                if (result.$2) {
                } else {
                  /*used to show meesage for eroor*/
                  customSnackBar(context, result.$1);
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
            child: Text("Sign in"),
          ),

          //****************************************************
          const SizedBox(height: 16),
          //***************************************************************
          //to reset yor password
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Enter your email"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          //user enter paasword want to change
                          controller: resetPasswordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            //Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Colors.grey[200] ?? Colors.grey),
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
                    actions: [
                      //button appear after user enter pass they want
                      TextButton(
                        onPressed: () async {
                          if (resetPasswordController.text.isNotEmpty) {
                            //forget pass
                            await authProvider
                                .resetPassword(resetPasswordController.text);
                            //resetPassword method i created
                            if (context.mounted) {
                              customSnackBar(
                                  context, "Email has been sent to you");
                              Navigator.pop(context);
                            }//inner if
                          }
                        },
                        child: Text("Reset"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Forget your password?"),
          ),
          Spacer(),
          //buttom for to move sign up screen***********************************
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                //*********************
                TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
                //*****************
                TextSpan(
                  text: " Sign up",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                    //changeIsLogging methos i create
                      /*this method when change log in will triger register screen*/
                      context.read<AppAuthProvider>().changeIsLogging();
                    },
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColorsLight.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //*******************
              ],
            ),

          ),
        ], //CHILDREN
      ),
    ); //
  }//widget
}//class log in
