import 'package:flutter/material.dart';
/*method used for costom dilog */
Future<void> customShowDialog({
  /*it take 3 arguments as require */
  /*BuildContext object in Flutter.
  It provides information about the location of a widget in the widget tree
   In this function, context is passed as a required argument
   to specify where in the widget tree the dialog should appear*/
  required BuildContext context,
  required String title,
  required String content,
  Text? subtitle, // Optional subtitle parameter
  Widget? acceptButton,//press ok
  Widget? cancelButton,//press cancel
  Widget? icon,// icon true false or ! wich is product not found
}) =>
//this method return show dialog
    showDialog(
      /*show dialog require context which is location to were should it appear*/
      //location of widget calles costom dialog
      context: context,
      /*builder parameter is a
      callback function that returns the widget tree for the dialog.

       The context passed to customShowDialog refers to the parent widget in the widget tree where the dialog is triggered.
The context inside the builder function refers to the widget tree of the dialog itself.
       */
      //location and data of show dialog it self
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                icon,
                const SizedBox(height: 4.0), // Space below icon
              ],//if


              Text(content),
              //show allergy ingreadins in product
              if (subtitle != null) ...[
                const SizedBox(height: 4.0), // Space below content
                subtitle


              ],//if


            ],//children
          ),
          //for 2 buttons ok and cancel
          actions: <Widget>[
            acceptButton ??
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    //context her represent location for dialog and then pop to return
                    Navigator.of(context).pop();
                  },
                ),
            cancelButton ??
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
          ],
        );
      },//builder
    );//show dialog
