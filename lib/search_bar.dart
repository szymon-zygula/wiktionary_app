import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(224, 224, 224, 1.0),
        borderRadius: BorderRadius.circular(1000.0)
      ),
      child: const TextField(
        maxLines: 1,
        cursorColor: Color.fromRGBO(64, 64, 64, 1.0),
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none
        )
      ),
    );
  }
}
