import 'package:allergy_helper_project/core/services/shared_preference.dart';
import 'package:flutter/material.dart';

class WelcomeProvider extends ChangeNotifier {
  bool showWelcomeScreen = true;
  bool welcomeScreenCheckbox = false;

  void fetchWelcomeScreenPreferences() {
    //fetchWelcomeScreenPreferences return welcon screen
    final pref = SharedPreference.fetchWelcomeScreenPreferences();
    if (pref != null) {
      //showWelcomeScreen is bool
      showWelcomeScreen = pref;
    }

    notifyListeners();
  }
//from true to false , false to true
  void updateWelcomeScreenCheckbox() {
    welcomeScreenCheckbox = !welcomeScreenCheckbox;
    notifyListeners();
  }
//when showWelcomeScreen is false i want it true
  void setWelcomeScreenPreferences([bool? force]) {
    if (welcomeScreenCheckbox || (force ?? false)) {
      SharedPreference.setWelcomeScreenPreferences(!showWelcomeScreen);
    }
  }

  // Welcome page index controller
  int currentIndex = 0;

  bool get lastPage => currentIndex == 2;

  void updatePage(int page) {
    currentIndex = page;
    notifyListeners();
  }

  void nextPage() {
    if (currentIndex < 2) {
      currentIndex += 1;
      updatePage(currentIndex);
    }
    debugPrint("There is no next pages");
  }

  void previousPage() {
    if (currentIndex >= 0) {
      currentIndex -= 1;
      updatePage(currentIndex);
    }
    debugPrint("There is no previous pages");
  }

  void changeShowWelcomeScreenState() {
    showWelcomeScreen = !showWelcomeScreen;
    notifyListeners();
  }
}
