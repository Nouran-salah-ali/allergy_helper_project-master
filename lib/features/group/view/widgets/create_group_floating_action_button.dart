import 'package:allergy_helper_project/core/theme/app_colors/app_colors_light.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateGroupFloatingActionButton extends StatelessWidget {
  const CreateGroupFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor:  AppColorsLight.primaryColor,
      onPressed: () => Navigator.pushNamed(context, "/create_group"),//CreateGroupScreen 
      child: FaIcon(FontAwesomeIcons.plus),//[+]
    );
  }
}
