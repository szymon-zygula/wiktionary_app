import 'package:flutter/material.dart';
import 'debug.dart';

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSnackBar(context, "<-- return!");
      },
      child: const Icon(Icons.arrow_back, color: Colors.grey, size: 48.0)
    );
  }
}

