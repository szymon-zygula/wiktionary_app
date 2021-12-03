import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'generic_entry_list.dart';
import 'custom_buttons.dart';

final List<String> dummyLanguages = <String>[
  'polski', 'italiano', 'français', 'deutsch', 'English',
  'русский', 'svenska', 'lingua latina', 'español',
  'srbski', 'hrvatski', 'magyar', 'ślůński', 'esperanto',
  'lietuvų', 'kaszëbsczi', 'беларуская'
];

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderBarWithBackButton(),
        GenericEntryList(dummyLanguages)
      ]
    );
  }
}

class HeaderBarWithBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CustomBackButton(),
          HeaderBar(),
        ]
      )
    );
  }
}

class HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        child: const Text(
          'Available languages',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          )
        )
      )
    );
  }
}
