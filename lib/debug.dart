import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  var snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Feedback.forTap(context);
}
