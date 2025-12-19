import 'package:flutter/material.dart';

//class SizeConfig will provide all informations needed on my UI 
class SizeConfig {
  //declare variables as static which means value is shared among all instances of the SizeConfig class
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    //give the variables value,MediaQuery provides information about the current media, such as the size of the screen.
    screenWidth = MediaQuery.of(context) .size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context) .orientation;

    /*if orientation landscape take height of the screen
    if not landscape take width
    */
    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * 0.024 // we multible the H, W to make it smaller 
        : screenWidth! * 0.024;
        

    print('this is the default size $defaultSize');
  }
}