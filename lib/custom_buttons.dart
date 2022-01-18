import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'router_delegate.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton() : super(key: const Key('CustomBackButton'));

  @override
  Widget build(BuildContext context) {
    MyRouterDelegate routerDelegate = Get.find();
    return CustomButton(
        Icons.arrow_back, AppLocalizations.of(context)!.goBackButton, () {
      routerDelegate.popRoute();
    });
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final double size;
  final String label;

  CustomButton(this.icon, this.label, this.onTap, {this.size = 48.0})
      : super(key: Key('CustomButton:$label:$size'));

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.grey,
          size: size,
        ),
      ),
    );
  }
}
