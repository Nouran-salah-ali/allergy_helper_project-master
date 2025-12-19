import 'dart:convert';

// To save allergies preferences to the device using shared preferences we need to convert to json (string type of data)
// because shared preferences does not storage complex objects like a map, then we can convert it back to Map using the class
/*to save data to device we have to use sheared preferences
sheared preferences save data but primitive not reference
allerges are in reference map  so we have to convert map to jison
 */
class AllergyModel {
  static String allergiesToJson(Map<String, bool> allergies) {
    /*convert map value from bool to int */
    Map<String, int> allergiesIntMap =
        allergies.map((key, value) => MapEntry(key, value ? 1 : 0));
    //return jison
    return jsonEncode(allergiesIntMap);
  }//allergiesToJson

  static Map<String, bool> allergiesToMap(String jsonString) {
    /*convert from jison to map*/
    Map<String, dynamic> allergiesIntMap = jsonDecode(jsonString);
    /*convert int to bool*/
    Map<String, bool> allergies =
        allergiesIntMap.map((key, value) => MapEntry(key, value == 1));
    //return last list string bool
    return allergies;
  }//allergiesToMap
}//AllergyModel
