import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/auth/view/widgets/logging_screen.dart';
import 'package:allergy_helper_project/features/auth/view/widgets/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //list of pages
    final pages = [
      LoggingScreen(),
      RegisterScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AppAuthProvider>(
          //if log in true go page 0 if false page 0
          builder: (context, provider, _) => pages[provider.isLogging ? 0 : 1],
        ),
      ),
    );
  }
}
