import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'custom_buttons.dart';
import 'debug.dart';

class ArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarWithButtons(),
      ]
    );
  }
}

class SearchBarWithButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CustomBackButton(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SearchBar()
            )
          ),
          CustomButton(Icons.language, () { showSnackBar(context, 'Changement de la langue !'); })
        ]
      )
    );
  }
}
