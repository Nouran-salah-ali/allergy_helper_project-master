import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:allergy_helper_project/features/barcode/view/widgets/barcode_floating_action_button.dart';
import 'package:allergy_helper_project/features/group/view/group_list_screen.dart';
import 'package:allergy_helper_project/features/group/view/widgets/create_group_floating_action_button.dart';
import 'package:allergy_helper_project/features/home/logic/home_provider.dart';
import 'package:allergy_helper_project/features/home/view/widgets/home_screen_widget.dart';
import 'package:allergy_helper_project/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /* Create List of Bars 
    , for: Home, Groubs,Profile */
    final List<AppBar> appBars = [// Contains multiple AppBar widgets for different tabs./such as :home, groubs,profile
      AppBar(// the app bar for home, contains title, IconButton that has navigater and icon shape and color
        title: Text("Allergy Helper"),//**title for Home page
        actions: [//  list of widgets (typically buttons or icons) that are displayed in the top-right corner of the AppBar
          IconButton(//button that contains an icon
            onPressed: () {
              Navigator.of(context).pushNamed("/search_product_screen");//ProductSearchScreen()
            },
            icon: Icon(
              Icons.search,//icon shape 
              color: AppColorsLight.primaryColor,
            ),
          ),
        ],
      ),
      AppBar(//appbar for the chats
        title: Text("Group chats"),//**title for Groubs page
        actions: [
          IconButton(
            onPressed: () { 
              Navigator.of(context).pushNamed("/discover_groups");// DiscoverGroubScreen()
            },
            icon: Icon(
              Icons.search,//shape of icon
              color: Colors.blue,
            ),
          ),
        ],
      ),
      AppBar(),//Nothing for Profile page 
    ];
  /* Create list of the tabs that will be used later */
    final List<Widget> tabs = [// will be used later on the code (line 63 )
      HomeScreenWidget(),
      GroupListScreen(),
      ProfileScreen(),
    ];
    /*Accesses the HomeProvider state and listens 
    for changes (e.g., when the currentIndex changes). */
    return Consumer<HomeProvider>(//Accesses the HomeProvider state and listens for changes (e.g., when the currentIndex changes).
      builder: (context, provider, _) => Scaffold(//builder:callback that gives access to:, context:current widget context,provider: The instance of HomeProvider, which contains the state and logic., Scaffold: Provides the overall structure of the screen 
        appBar: appBars[provider.currentIndex],//determines which AppBar and tab content to display.appbars on line 17
        body: Padding( //Determines the main content of the screen
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          child: tabs[provider.currentIndex],//Chooses the content of the screen based on currentIndex, determint based on the tap list in line 49,e.g: index 0 = HomeScreenWidget
        ),

        bottomNavigationBar: BottomNavigationBar(/*Displays three navigation options: Home, Groups, and Profile*/
          currentIndex: provider.currentIndex,// currently active tab
          onTap: (int index) {// to update the current tab when the user taps an item.eg: index 0: Home
            provider.updateCurrentPage(index);
          },
          items: [//for each bottomnavigattion will give icon+lable
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Groups",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        floatingActionButton: provider.currentIndex == 0 //Displays a button based on the selected tab:
            ? BarcodeFloatingActionButton()//Tab 0 (Home): Shows the barcode button
            : provider.currentIndex == 1// im on page 1 which is page for groubs, so display the create groubes button
            ? CreateGroupFloatingActionButton()
            : null,
      ),
    );
  }
}
