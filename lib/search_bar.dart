import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'router_delegate.dart';

class SearchBar extends StatelessWidget {
  const SearchBar() : super(key: const Key('SearchBar'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(224, 224, 224, 1.0),
        borderRadius: BorderRadius.circular(1000.0),
      ),
      child: const TextField(
        autofocus: true,
        maxLines: 1,
        cursorColor: Color.fromRGBO(64, 64, 64, 1.0),
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class DummySearchBar extends StatelessWidget {
  const DummySearchBar() : super(key: const Key('SearchBar'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(224, 224, 224, 1.0),
        borderRadius: BorderRadius.circular(1000.0),
      ),
      child: TextField(
        maxLines: 1,
        cursorColor: const Color.fromRGBO(64, 64, 64, 1.0),
        onTap: () {
          MyRouterDelegate routerDelegate = Get.find();
          routerDelegate.pushPage('/search');
        },
        decoration: const InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
