import 'package:allergy_helper_project/features/product/data/allergy_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
//No database setup is required, making it ideal for simple data like settings.
/*Shared preferences allow me to store small amounts of data
user preferences locally on a device in a key-value format.
* here we rae vinding value of screen welcom and sitting it and the value in device */
class SharedPreference {
  // pref Global instance.
  /*static so it can be accessed without creating an instance of SharedPreference.*/
  static late SharedPreferences pref;

  // Initializing the shared preference instance, called in main.dart file.
  static initSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  // Welcome screen.
  static const String welcomePreferencesKey = "welcome_screen";

  /*pref.getBool(welcomePreferencesKey) looks up the value for the key "welcome_screen".
*/
  static bool? fetchWelcomeScreenPreferences() {
    final result = pref.getBool(welcomePreferencesKey);
    print(result);
    /*If the value exists (result != null), it is returned.
If the value does not exist, null is returned.*/
    if (result != null) return result;
    return null;
  }
/*stores the value (true or false) for the key "welcome_screen".*/
  static void setWelcomeScreenPreferences(bool value) async {
    final result = await pref.setBool(welcomePreferencesKey, value);
    debugPrint("$result: set welcomeScreen value to: $value");
  }


}
