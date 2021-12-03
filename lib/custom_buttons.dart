import 'package:flutter/material.dart';
import 'debug.dart';

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(Icons.arrow_back, () {
        showSnackBar(context, "<-- return!");
      }
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final double size;

  CustomButton(this.icon, this.onTap, {this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: Colors.grey, size: size)
    );
  }
}
