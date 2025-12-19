import 'package:flutter/material.dart';
//  alert any widgets that depend on HomeProvider to rebuild
class HomeProvider extends ChangeNotifier {//ChangeNotifier: allows widgets to rebuild when the state changes.
  int currentIndex = 0;
/*every time i use method it will send current page number to it
 so it will notify page depend on home provider to rebuild*/
  void updateCurrentPage(int newPage){
    currentIndex = newPage;
    notifyListeners();//when there is change it will be called to rebuild
  }
}
