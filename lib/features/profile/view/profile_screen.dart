import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/home/logic/home_provider.dart';
import 'package:allergy_helper_project/features/product/logic/product_provider.dart';
import 'package:allergy_helper_project/features/welcome/logic/welcome_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =Provider.of<AppAuthProvider>(context, listen: false).userModel!;
       // detailed information about the user beyond what is provided by Firebase's User object.
  //For example, it might contain the user's username, profile picture URL, email, and other custom data.

    return Padding(// adds space around its child.
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      child: Column(// column arranges its children vertically
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [// represents the list of child widgets that will be displayed within the parent widget
          CircleAvatar(//user's profile image.
            radius: 60.0,
            backgroundColor: AppColorsLight.primaryColor.withOpacity(0.2),
            child: CircleAvatar(// display a circular avatar, typically for user profile pictures or icons.
              radius: 56.0,
              backgroundImage: CachedNetworkImageProvider(// display an image inside the circle
                user.profileUrl,
              ),
            ),
          ),
          const SizedBox(height: 16),//spacing
          Text(//displaying user name
            user.username,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(//displayong the project name 
            "Allergy Helper Project",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          /*Card widget in Flutter, 
          with a rounded border and a series of ListTile*/
          Card(
            shape: RoundedRectangleBorder(// card has a rounded border
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(//used to arrange the ListTile widgets vertically
                children: [//has multible listtitles represinting a clickable item in the list.
                 
                  ListTile(//edit profile
                    leading: const Icon(
                      Icons.edit,
                      color: AppColorsLight.primaryColor,
                    ),
                    title: const Text("Edit Profile"),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 18),
                    onTap: () =>
                        Navigator.of(context).pushNamed("/edit_profile_screen"),
                  ),
                  const Divider(),

                  ListTile(//edit food preferences
                    leading: const Icon(
                      Icons.restaurant_menu,
                      color: AppColorsLight.primaryColor,
                    ),
                    title: const Text("Food Preferences"),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 18),
                    onTap: () =>
                        Navigator.of(context).pushNamed("/allergies_list"),
                  ),
                  const Divider(),

                  ListTile(// -change password
                    leading: const Icon(
                      Icons.lock,
                      color: AppColorsLight.primaryColor,//claaing the class of color that defined earleir
                    ),
                    title: const Text("Change Password"),
                    trailing: const Icon(Icons.arrow_forward_ios,// place a widget (typically an icon) at the end (right side) of the ListTile.
                        color: Colors.grey, size: 18),
                    onTap: () =>
                        Navigator.pushNamed(context, "/change_password"),// go to ChangePasswordScreen
                  ),
                  const Divider(),//adds a thin horizontal line between the ListTile and the next widget.

                  ListTile(//reset welcome screen
                    leading: const Icon(
                      Icons.refresh,
                      color: AppColorsLight.primaryColor,
                    ),
                    title: const Text("Reset Welcome Screen"),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 18),
                    onTap: () => context
                        .read<WelcomeProvider>()
                        .setWelcomeScreenPreferences(true),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),// create empty space within a Column 
          ElevatedButton(// -Log out
            style: ElevatedButton.styleFrom(// used to customize the appearance of the ElevatedButton.
              padding: const EdgeInsets.symmetric(vertical: 16),//provide space above and below the text
              shape: RoundedRectangleBorder(//shape of the button with rounded corners.
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(//border around the button. 
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
            //After logging out, it's common for apps to return to a default state
            onPressed: () {// when the user taps the button
              context.read<ProductProvider>().reset();// resets the allergy data in your app
              context.read<AppAuthProvider>().logout();//log out of firebase
              context.read<HomeProvider>().updateCurrentPage(0);//user is taken to a neutral, expected place
            },
            child: const Text(//text on button
              "Logout",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
