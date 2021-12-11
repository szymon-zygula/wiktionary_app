import 'package:flutter/material.dart';
import 'search_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen() : super(key: const Key('_MainScreen'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _WiktionaryHeader(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const SearchBar(),
        )
      ],
    );
  }
}

class _WiktionaryHeader extends StatelessWidget {
  const _WiktionaryHeader() : super(key: const Key('_WiktionaryHeader'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: const Image(
          image: AssetImage('assets/logo.png'), width: 325, height: 325),
    );
  }
}
