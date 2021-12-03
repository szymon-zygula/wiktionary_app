import 'package:flutter/material.dart';
import 'search_bar.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WiktionaryHeader(),
        SearchBar()
      ]
    );
  }
}

class WiktionaryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10),
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
