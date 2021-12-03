import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(224, 224, 224, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(200))
        ),
        child: const TextField(
          maxLines: 1,
          cursorColor: Color.fromRGBO(64, 64, 64, 1.0),
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none
          )
        ),
      )
    );
  }
}
