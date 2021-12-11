import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'article_viewer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen() : super(key: const Key(""));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const WiktionaryHeader(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SearchBar(),
        )
      ],
    );
  }
}

class WiktionaryHeader extends StatelessWidget {
  const WiktionaryHeader() : super(key: const Key(""));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: const Image(
          image: AssetImage('assets/logo.png'), width: 325, height: 325),
    );
  }
}
