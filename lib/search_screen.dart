import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'generic_entry_list.dart';

final List<String> dummySearches = <String>[
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen',
  'szołdra', 'snycerz', 'acquiesce', 'herfallen'
];

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBar(),
        HistoryHeader(),
        GenericEntryList(dummySearches)
      ]
    );
  }
}

class HistoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
      child: const Text(
        'Recent searches:',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
        )
      )
    );
  }
}
