import 'package:flutter/material.dart';
import 'debug.dart';

class GenericEntryList extends StatelessWidget {
  final List<String> entries;

  GenericEntryList(this.entries)
      : super(key: Key('GenericEntryList:${entries.toString()}'));

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return _GenericEntry(entries[index]);
        },
      ),
    );
  }
}

class _GenericEntry extends StatelessWidget {
  final String entry;

  _GenericEntry(this.entry) : super(key: Key('GenericEntry:$entry'));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSnackBar(context, entry);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          entry,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
