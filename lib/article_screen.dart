import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'custom_buttons.dart';
import 'debug.dart';
import 'article_viewer.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen() : super(key: const Key(""));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SearchBarWithButtons(),
        ArticleViewer('en', 'manger'),
      ],
    );
  }
}

class SearchBarWithButtons extends StatelessWidget {
  const SearchBarWithButtons() : super(key: const Key(""));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CustomBackButton(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SearchBar(),
            ),
          ),
          CustomButton(Icons.language, () {
            showSnackBar(context, 'Changement de la langue !');
          }),
        ],
      ),
    );
  }
}
