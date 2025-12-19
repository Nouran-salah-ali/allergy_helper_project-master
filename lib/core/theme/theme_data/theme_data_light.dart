import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:flutter/material.dart';
/*Flutter's ThemeData is a class that
holds the configuration for an app's visual styling*/
ThemeData get themeDataLight => ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColorsLight.primaryColor,
      ),
      fontFamily: 'Poppins', // Default font
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
