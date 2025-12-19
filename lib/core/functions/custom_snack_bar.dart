import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar(
    BuildContext context, String content) {
  // Step 1: Hide the current SnackBar if it's showing
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // Step 2: Show a new SnackBar with the provided content
  return ScaffoldMessenger.of(context).showSnackBar(// shows the SnackBar in the app with the specified content.
    SnackBar(
      content: Text(content),
    ),
  );
}
