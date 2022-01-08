import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'router_delegate.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton() : super(key: const Key('CustomBackButton'));

  @override
  Widget build(BuildContext context) {
    MyRouterDelegate routerDelegate = Get.find();
    return CustomButton(Icons.arrow_back, () {
      routerDelegate.popRoute();
    });
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final double size;

  const CustomButton(this.icon, this.onTap, {this.size = 48.0})
      : super(key: const Key('CustomButton'));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.grey,
        size: size,
      ),
    );
  }
}
