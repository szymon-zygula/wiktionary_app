import 'package:flutter/material.dart';
import 'debug.dart';

class GenericEntryList extends StatelessWidget {
  final List<String> entries;

  GenericEntryList(this.entries);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return GenericEntry(entries[index]);
        }
      )
    );
  }
}

class GenericEntry extends StatelessWidget {
  final String entry;

  GenericEntry(this.entry);

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
          style: const TextStyle(
            fontSize: 18
          )
        )
      )
    );
  }
}
