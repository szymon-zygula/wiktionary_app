import 'package:flutter/material.dart';

class GenericEntryList extends StatelessWidget {
  final List<String> entries;
  final List<Object> entryValues;
  final Function(Object)? onTap;

  GenericEntryList(this.entries, this.entryValues, {this.onTap})
      : super(key: Key('GenericEntryList:${entries.toString()}'));

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return _GenericEntry(
            entries[index],
            entryValues[index],
            onTap: onTap,
          );
        },
      ),
    );
  }
}

class _GenericEntry extends StatelessWidget {
  final Object entryValue;
  final String entry;
  final Function(Object)? onTap;

  _GenericEntry(this.entry, this.entryValue, {this.onTap})
      : super(key: Key('GenericEntry:$entry:$entryValue'));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(entryValue);
        }
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
