
import 'package:allergy_helper_project/core/services/shared_preference.dart';
import 'package:allergy_helper_project/core/theme/theme_data/theme_data_light.dart';
import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/auth/view/auth_screen.dart';
import 'package:allergy_helper_project/features/auth/view/change_password_screen.dart';
import 'package:allergy_helper_project/features/auth/view/edit_profile_screen.dart';
import 'package:allergy_helper_project/features/auth/view/widgets/register_screen.dart';
import 'package:allergy_helper_project/features/group/logic/group_provider.dart';
import 'package:allergy_helper_project/features/group/logic/message_provider.dart';
import 'package:allergy_helper_project/features/group/view/create_group_screen.dart';
import 'package:allergy_helper_project/features/group/view/discover_groups_screen.dart';
import 'package:allergy_helper_project/features/home/logic/home_provider.dart';
import 'package:allergy_helper_project/features/home/view/home_screen.dart';
import 'package:allergy_helper_project/features/product/logic/product_provider.dart';
import 'package:allergy_helper_project/features/product/view/product_search_screen.dart';
import 'package:allergy_helper_project/features/product/view/widgets/allergies_list.dart';
import 'package:allergy_helper_project/features/profile/view/profile_screen.dart';
import 'package:allergy_helper_project/features/welcome/logic/welcome_provider.dart';
import 'package:allergy_helper_project/features/welcome/view/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'old_project/prudctsData.dart';

void main() async {
  // Make sure that the Flutter engine is fully initialized before any widgets are built.
  WidgetsFlutterBinding.ensureInitialized();

  // Create instance from shared preferences to save and fetch data from mobile storage.
  await SharedPreference.initSharedPref();

  // Initializing firebase to use firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set Firebase Firestore settings.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Enable offline persistence.
  );
  //to add data to fire base addProductsToFirestore();
  addProductsToFirestore();
  runApp(
    // This a state management called [Provider] it manages and transfer the data to all app widgets using [context].
    MultiProvider(
      providers: [
        // For each kind of data we create a class, it's like a data warehouse.
        ChangeNotifierProvider(
          create: (context) =>
              WelcomeProvider()..fetchWelcomeScreenPreferences(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppAuthProvider()..changeIsLogging(true),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => GroupProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WelcomeProvider>(
      builder: (context, welcomeProvider, _) => MaterialApp(
        theme: themeDataLight,
        debugShowCheckedModeBanner: false,
        home: Consumer<AppAuthProvider>(
          builder: (context, authProvider, child) => welcomeProvider
                  .showWelcomeScreen
              ? WelcomeScreen()
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        body: Center(
                          child: const CircularProgressIndicator(),
                        ),
                      ); // Loading indicator
                    } else if (snapshot.hasData) {
                      if (authProvider.isWaitingUserModel) {
                        return Scaffold(
                          body: Center(
                            child: const CircularProgressIndicator(),
                          ),
                        ); // Loading indicator
                      } else if (authProvider.userModel?.firstTimeLogging ==
                          true) {
                        //firct timr log in true return select
                        return AllergiesList(
                          isFirstTimeLogging: true,
                        ); // Navigate to preferences
                      } else {
                        //not first time return home
                        return HomeScreen(); // Navigate to home
                      }
                    } else {
                      // Otherwise, navigate to the Auth screen
                      return AuthScreen();
                    }
                  },
                ),
        ),
        routes: {
          "/auth_screen": (context) => const AuthScreen(),
          "/register_screen": (context) => const RegisterScreen(),
          "/home_screen": (context) => const HomeScreen(),
          "/profile_screen": (context) => const ProfileScreen(),
          "/allergies_list": (context) => const AllergiesList(),
          "/create_group": (context) => const CreateGroupScreen(),
          "/discover_groups": (context) => const DiscoverGroupsScreen(),
          "/edit_profile_screen": (context) => const EditProfileScreen(),
          "/search_product_screen": (context) => const ProductSearchScreen(),
          "/change_password": (context) => const ChangePasswordScreen(),
        },
        
      ),
    );
  }
}
