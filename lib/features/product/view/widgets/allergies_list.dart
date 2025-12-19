import 'package:allergy_helper_project/features/auth/logic/app_auth_provider.dart';
import 'package:allergy_helper_project/features/product/logic/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
/*AllergiesList, which is a screen that allows users to select their allergies
 from a list and save their preferences.*/
/*Display Allergies:
* Shows a list of allergies with checkboxes indicating whether each allergy is selected.
*
Update Allergies:
Users can select or deselect allergies by checking/unchecking the boxes.
Changes are saved to ProductProvider in real-time.
*
Save Allergies:
On pressing "Save Allergies," the data is saved to the database and recommendations are updated.
If the user is not logging in for the first time, they are returned to the previous screen.*/
class AllergiesList extends StatelessWidget {
  final bool isFirstTimeLogging;

  const AllergiesList({
    super.key,
    //default is false
    this.isFirstTimeLogging = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Allergies")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        /*Consumer<ProductProvider> allow us to acees all data from ProductProvider
        * When you wrap a widget with a Consumer,
        * that widget rebuilds whenever the ProductProvider's data changes
        *  (notified via notifyListeners()).*/
        child: Consumer<ProductProvider>(
          /*Rebuilds this portion of the widget tree whenever ProductProvider triggers notifyListeners().
          *provider name for ProductProvider */
          builder: (context, provider, _) {
            //provider.allergies;  is list in provider class contain all alleges
            final allergiesList = provider.allergies;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /*Loops through allergiesList.keys (allergy names) and creates a CheckboxListTile for each.
                  * every time take key and create CheckboxListTil*/
                  ...allergiesList.keys.map((key) {
                    /*CheckboxList take 3 parameter
                     title is key
                     and value checked or not is the value of key
                     on changed when user press on check box */
                    return CheckboxListTile(
                      title: Text(key),
                      value: allergiesList[key],
                      onChanged: (value) {
                        /*updateAllergiesStatus is method in provider class it change value to opposite
                        true to false
                        false to true
                        for example user checked milk update method work on change
                        value from false to true
                         notifyListeners() causes the Consumer<ProductProvider> widget (and its child widgets) to rebuild.
                         and rebuild widget and the map iterate again from start  and sat value of
                        checked box true for milk
                        allergiesList map is re-read from the provider, now with updated values
                        The map method iterates over allergiesList.keys again, recreating the CheckboxListTile widgets:*/
                        provider.updateAllergiesStatus(key);
                      },
                    );
                  }//...allergiesList.keys
                  ),//map

                  /*button that saves the user's allergy selections*/
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),//style from
                    onPressed: () {
                      /*Calls provider.updateRecommendations() to refresh product recommendations based on selected allergies.*/
                      provider.updateRecommendations();
                      // provider.setAllergiesPreferences();
                      /*Uses the AppAuthProvider's updateUserAllergiesOnDatabase method to save the selected allergies
                       (provider.selectedAllergies) in the database.*/
                      /*listen: false
                      indicates that the widget accessing the provider does not need to rebuild
                      if the AppAuthProvider's data changes.provider's data changes.*/
                      Provider.of<AppAuthProvider>(context, listen: false)
                          .updateUserAllergiesOnDatabase(
                              provider.selectedAllergies);
                      /*If isFirstTimeLogging is false,
                       means user is not new and he is editing preferences from profile screen
                       navigates back to the previous screen using Navigator.pop. which is profile */
                      if (!isFirstTimeLogging) {
                        Navigator.pop(context);
                        Provider.of<AppAuthProvider>(context, listen: false)
                            .updateUserAllergiesOnDatabase(
                                provider.selectedAllergies);
                      }//if
                    },//on pressed
                    child: Text('Save Allergies'),
                  ),
                ],
              ),
            );
          },//builder: (context, provider, _)
        ),
      ),
    );
  }//build
}//AllergiesList
