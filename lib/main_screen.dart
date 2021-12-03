import 'package:flutter/material.dart';
import 'search_bar.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WiktionaryHeader(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SearchBar(),
        )
      ]
    );
  }
}

class WiktionaryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25, top: 15, bottom: 5),
      child: const Text(
        'Wiktionary',
        style: TextStyle(
          fontSize: 35,
          fontFamily: 'Serif'
        )
      )
    );
  }
}
