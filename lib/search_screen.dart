import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'generic_entry_list.dart';
import 'custom_buttons.dart';
import 'debug.dart';

final List<String> dummySearches = <String>[
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen',
  'głowica',
  'penna',
  'esquiver',
  'srbski',
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen',
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen',
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen',
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen',
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen',
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen',
  'szołdra',
  'snycerz',
  'acquiesce',
  'herfallen'
];

class SearchScreen extends StatelessWidget {
  const SearchScreen() : super(key: const Key('SearchScreen'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SearchBarWithBackButton(),
        _HistoryHeader(),
        GenericEntryList(dummySearches)
      ],
    );
  }
}

class _SearchBarWithBackButton extends StatelessWidget {
  const _SearchBarWithBackButton()
      : super(key: const Key('_SearchBarWithBackButton'));

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
                  child: const SearchBar())),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
            child: const Text(
              'Recent searches:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 20, bottom: 10),
          child: CustomButton(
            Icons.delete,
            () {
              showSnackBar(context, 'Supprimer l\'histoire');
            },
            size: 32.0,
          ),
        )
      ],
    );
  }
}
