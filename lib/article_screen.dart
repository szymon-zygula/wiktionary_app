import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'search_bar.dart';
import 'custom_buttons.dart';
import 'article_viewer.dart';
import 'router_delegate.dart';

class ArticleScreen extends StatelessWidget {
  final String language;
  final String articleName;

  ArticleScreen({required this.language, required this.articleName})
      : super(key: Key('ArticleScreen:$language:$articleName'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchBarWithButtons(articleName, language),
        ArticleViewer(language, articleName),
      ],
    );
  }
}

class _SearchBarWithButtons extends StatelessWidget {
  final String articleName;
  final String articleLanguage;

  const _SearchBarWithButtons(this.articleName, this.articleLanguage)
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
              child: DummySearchBar(
                onTap: () {
                  MyRouterDelegate routerDelegate = Get.find();
                  routerDelegate.popRoute();
                },
              ),
            ),
          ),
          CustomButton(Icons.language,
              AppLocalizations.of(context)!.changeLanguageButton, () {
            MyRouterDelegate routerDelegate = Get.find();
            routerDelegate.pushPage('/language', arguments: {
              // articleLanguage instead of Localizations because
              // the article may not exist in current localization language
              'articleLanguage': articleLanguage,
              'articleName': articleName,
            });
          }),
        ],
      ),
    );
  }
}
