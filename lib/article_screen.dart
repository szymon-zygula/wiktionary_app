import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'custom_buttons.dart';
import 'debug.dart';
import 'article_viewer.dart';

class ArticleScreen extends StatelessWidget {
  final String language;
  final String articleName;

  const ArticleScreen({required this.language, required this.articleName})
      : super(key: const Key('ArticleScreen'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SearchBarWithButtons(),
        ArticleViewer(language, articleName),
      ],
    );
  }
}

class _SearchBarWithButtons extends StatelessWidget {
  const _SearchBarWithButtons()
      : super(key: const Key('_SearchBarWithButtons'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const CustomBackButton(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const DummySearchBar(),
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
